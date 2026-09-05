import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// The country facts a phone field needs but [PhoneCountryData] does not expose:
/// a flag glyph, a `+90` style dial code and the national half of the phone mask.
extension PhoneCountryDataX on PhoneCountryData {
  String get isoCode => (countryCode ?? '').toUpperCase();

  String get dialCode => '+${phoneCode ?? ''}';

  String get displayName => country ?? isoCode;

  /// Regional indicator symbols: two ASCII letters render as one flag glyph,
  /// so no asset or extra package is needed to show a country.
  String get flagEmoji {
    if (isoCode.length != 2) return '';
    const regionalIndicatorA = 0x1F1E6;
    const asciiA = 0x41;
    final first = isoCode.codeUnitAt(0) - asciiA;
    final second = isoCode.codeUnitAt(1) - asciiA;
    if (first < 0 || first > 25 || second < 0 || second > 25) return '';
    return String.fromCharCode(regionalIndicatorA + first) +
        String.fromCharCode(regionalIndicatorA + second);
  }

  /// The mask with the dial code stripped, e.g. `000 000 00 00` for TR.
  /// The dial code lives in the country trigger, never in the text field.
  String get nationalMask {
    if (phoneMask == null || phoneCode == null) return '';
    return phoneMaskWithoutCountryCode.trim();
  }

  int get nationalDigitCount => '0'.allMatches(nationalMask).length;
}

/// Lookup and search over the country list that [PhoneInputFormatter] knows about.
class PhoneCountries {
  const PhoneCountries._();

  static List<PhoneCountryData>? _sortedAll;

  /// Every known country, sorted by display name.
  static List<PhoneCountryData> all() {
    return _sortedAll ??= List<PhoneCountryData>.from(
      PhoneCodes.getAllCountryDatas(),
    )..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  static PhoneCountryData? byIsoCode(String? isoCode) {
    if (isoCode == null || isoCode.length != 2) return null;
    return PhoneCodes.getPhoneCountryDataByCountryCode(isoCode.toUpperCase());
  }

  /// The country a full `+905527802864` number belongs to.
  static PhoneCountryData? byPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return null;
    return PhoneCodes.getCountryDataByPhone(phoneNumber);
  }

  /// An empty [isoCodes] means "no restriction", so a caller that does not care
  /// about a corridor gets the whole world instead of an empty picker.
  static List<PhoneCountryData> resolve(List<String> isoCodes) {
    if (isoCodes.isEmpty) return all();
    final resolved = <PhoneCountryData>[];
    final seen = <String>{};
    for (final code in isoCodes) {
      final country = byIsoCode(code);
      if (country != null && seen.add(country.isoCode)) {
        resolved.add(country);
      }
    }
    resolved.sort((a, b) => a.displayName.compareTo(b.displayName));
    return resolved;
  }

  /// Matches a name, a dial code (`+90`, `90`) or an ISO code (`TR`).
  static List<PhoneCountryData> search(
    List<PhoneCountryData> source,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return source;
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    return source.where((country) {
      if (country.displayName.toLowerCase().contains(trimmed)) return true;
      if (country.isoCode.toLowerCase() == trimmed) return true;
      return digits.isNotEmpty && (country.phoneCode ?? '').startsWith(digits);
    }).toList();
  }
}

/// Digits only, so a masked field value can be turned back into a raw number.
String phoneDigitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

/// Runs [value] through the same masking path typing goes through, so a
/// programmatically set number and a typed one always look identical.
String formatNationalNumber(String value, {required String isoCode}) {
  final digits = phoneDigitsOnly(value);
  if (digits.isEmpty || isoCode.length != 2) return digits;
  final formatter = PhoneInputFormatter(
    defaultCountryCode: isoCode,
    shouldCorrectNumber: false,
  );
  return formatter
      .formatEditUpdate(
        const TextEditingValue(),
        TextEditingValue(
          text: digits,
          selection: TextSelection.collapsed(offset: digits.length),
        ),
      )
      .text;
}
