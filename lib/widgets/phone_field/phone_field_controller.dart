import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneFieldController {
  final phoneController = TextEditingController();
  final countryController = ValueNotifier<PhoneCountryData?>(null);

  PhoneFieldController({
    String initialCountryCode = "TR",
    String? initialPhoneNumber,
  }) {
    if (initialPhoneNumber != null) {
      phoneController.text = initialPhoneNumber;
    }
  }

  String? getPhoneNumber() {
    if (phoneController.text.isEmpty) {
      return null;
    }
    final phoneCode = countryController.value?.phoneCode;
    return "+${phoneCode ?? ""}${phoneController.text.trim()}";
  }

  set countryCode(String countryCode) {
    final countryData = PhoneCodes.getPhoneCountryDataByCountryCode(
      countryCode,
    );
    countryController.value = countryData;
  }

  set phoneNumber(String phoneNumber) {
    final rawPhoneNumber = PhoneCodes.removeCountryCode(phoneNumber);
    phoneController.text = rawPhoneNumber;
  }

  void updateSelectedCountryWithPhoneCode(String phoneCode) {
    final countryData = PhoneCodes.getAllCountryDatasByPhoneCode(phoneCode);
    countryController.value = countryData.first;
  }

  void dispose() {
    phoneController.dispose();
    countryController.dispose();
  }
}
