import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_multi_formatter/widgets/country_dropdown.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_field_controller.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    this.onPhoneChanged,
    required this.phoneFieldController,
    this.label = "Telefon",
    this.validator,
    this.focusNode,
  });

  final PhoneFieldController phoneFieldController;
  final void Function(String)? onPhoneChanged;
  final String? Function(String?)? validator;
  final String label;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: phoneFieldController.countryController,
      builder: (context, value, child) {
        return Column(
          key: Key(value?.countryCode ?? "TR"),
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                Expanded(
                  flex: 3,
                  child: CountryDropdown(
                    initialCountryData: value,
                    alignment: Alignment.center,
                    triggerOnCountrySelectedInitially: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    filter: PhoneCodes.findCountryDatasByCountryCodes(
                      countryIsoCodes: ["TR"],
                    ),
                    onCountrySelected: _handleCountryChange,
                    dropdownColor: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TextFormField(
                    focusNode: focusNode,
                    validator: validator,
                    controller: phoneFieldController.phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    onChanged: onPhoneChanged,
                    decoration: InputDecoration(counterText: ""),
                    inputFormatters: [
                      // PhoneInputFormatter(
                      //   defaultCountryCode: value?.countryCode,
                      //   allowEndlessPhone: false,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  PhoneCountryData? getCountryDataByCountryCode(String code) {
    final countries = PhoneCodes.getAllCountryDatas();
    for (var country in countries) {
      if (country.country == code) {
        return country;
      }
    }
    return null;
  }

  void _handleCountryChange(PhoneCountryData countryData) {
    phoneFieldController.countryController.value = countryData;
  }
}
