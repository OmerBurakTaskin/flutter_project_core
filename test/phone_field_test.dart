import 'package:flutter_project_core/axii_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('national number is masked with the selected country mask', () {
    expect(formatNationalNumber('5527802864', isoCode: 'TR'), '552 780 2864');
    expect(formatNationalNumber('552', isoCode: 'TR'), '552');
  });

  test('controller returns E.164 without mask characters', () {
    final controller = PhoneFieldController();
    controller.phoneNumber = '5527802864';
    expect(controller.formattedNumber, '552 780 2864');
    expect(controller.getPhoneNumber(), '+905527802864');
    expect(controller.isValid, isTrue);
    controller.dispose();
  });

  test('a full number selects its country and drops the dial code', () {
    final controller = PhoneFieldController();
    controller.phoneNumber = '+491701234567';
    expect(controller.isoCode, 'DE');
    expect(controller.nationalNumber, '1701234567');
    expect(controller.getPhoneNumber(), '+491701234567');
    controller.dispose();
  });

  test('changing the country re-masks the digits already typed', () {
    final controller = PhoneFieldController();
    controller.phoneNumber = '5527802864';
    controller.countryCode = 'GB';
    expect(controller.isoCode, 'GB');
    expect(controller.nationalNumber, '5527802864');
    expect(controller.getPhoneNumber(), '+445527802864');
    controller.dispose();
  });

  test('empty iso list means every country, a list restricts it', () {
    expect(PhoneCountries.resolve(const []).length, greaterThan(200));
    final restricted = PhoneCountries.resolve(const ['TR', 'DE', 'XX']);
    expect(restricted.map((c) => c.isoCode), ['DE', 'TR']);
  });

  test('search matches name, iso code and dial code', () {
    final all = PhoneCountries.all();
    expect(PhoneCountries.search(all, 'turk').map((c) => c.isoCode),
        contains('TR'));
    expect(PhoneCountries.search(all, 'tr').map((c) => c.isoCode),
        contains('TR'));
    expect(PhoneCountries.search(all, '+90').map((c) => c.isoCode),
        contains('TR'));
  });

  test('flag emoji is derived from the iso code', () {
    expect(PhoneCountries.byIsoCode('TR')!.flagEmoji, '\u{1F1F9}\u{1F1F7}');
    expect(PhoneCountries.byIsoCode('TR')!.dialCode, '+90');
    expect(PhoneCountries.byIsoCode('TR')!.nationalMask, '000 000 0000');
  });
}
