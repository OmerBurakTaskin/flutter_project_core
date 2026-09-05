import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_country.dart';

/// Owns the two halves of a phone input: the selected country and the national
/// number. The text field holds a masked value, so every read goes through
/// [nationalNumber] and every write through [formatNationalNumber]; callers
/// never have to care whether a value was typed or set programmatically.
class PhoneFieldController {
  PhoneFieldController({
    String initialCountryCode = 'TR',
    String? initialPhoneNumber,
  }) {
    countryController = ValueNotifier<PhoneCountryData?>(
      PhoneCountries.byIsoCode(initialCountryCode),
    );
    if (initialPhoneNumber != null && initialPhoneNumber.isNotEmpty) {
      phoneNumber = initialPhoneNumber;
    }
  }

  final phoneController = TextEditingController();
  late final ValueNotifier<PhoneCountryData?> countryController;

  PhoneCountryData? get selectedCountry => countryController.value;

  String get isoCode => selectedCountry?.isoCode ?? '';

  /// The typed number without mask characters, e.g. `5527802864`.
  String get nationalNumber => phoneDigitsOnly(phoneController.text);

  /// What the user sees, e.g. `552 780 28 64`.
  String get formattedNumber => phoneController.text;

  bool get isEmpty => nationalNumber.isEmpty;

  /// E.164 without spaces, e.g. `+905527802864`. Null while the field is empty.
  String? getPhoneNumber() {
    final national = nationalNumber;
    if (national.isEmpty) return null;
    return '+${selectedCountry?.phoneCode ?? ''}$national';
  }

  String? get e164 => getPhoneNumber();

  /// True once the digits fill the selected country's mask.
  bool get isValid {
    final phone = getPhoneNumber();
    if (phone == null) return false;
    return isPhoneValid(phone);
  }

  set country(PhoneCountryData? country) {
    countryController.value = country;
    // The mask belongs to the country, so the same digits have to be re-masked.
    _applyFormatting();
  }

  set countryCode(String countryCode) {
    country = PhoneCountries.byIsoCode(countryCode);
  }

  /// Accepts either a national number or a full `+90...` one; a leading country
  /// code is stripped and, when it is unambiguous, also selects that country.
  set phoneNumber(String phoneNumber) {
    if (phoneNumber.trim().isEmpty) {
      clear();
      return;
    }
    if (phoneNumber.trim().startsWith('+')) {
      final matched = PhoneCountries.byPhoneNumber(phoneNumber);
      if (matched != null) countryController.value = matched;
      phoneController.text = PhoneCodes.removeCountryCode(phoneNumber.trim());
    } else {
      phoneController.text = phoneNumber;
    }
    _applyFormatting();
  }

  /// Selects the country a dial code belongs to; ambiguous codes such as +1
  /// resolve to the first match, which is what the picker shows first too.
  void updateSelectedCountryWithPhoneCode(String phoneCode) {
    final matches = PhoneCodes.getAllCountryDatasByPhoneCode(phoneCode);
    if (matches.isEmpty) return;
    country = matches.first;
  }

  void clear() {
    phoneController.clear();
  }

  void _applyFormatting() {
    final iso = isoCode;
    if (iso.isEmpty) return;
    final formatted = formatNationalNumber(phoneController.text, isoCode: iso);
    if (formatted == phoneController.text) return;
    phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void dispose() {
    phoneController.dispose();
    countryController.dispose();
  }
}
