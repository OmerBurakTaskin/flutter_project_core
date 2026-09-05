import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_project_core/src/widgets/phone_field/country_picker_bottom_sheet.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_country.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_field_controller.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_field_theme.dart';

/// Country trigger plus a masked national number input. Tapping the trigger
/// opens [showPhoneCountryPicker]; the number is masked with the selected
/// country's mask, and [PhoneFieldController.getPhoneNumber] gives back E.164.
///
/// Anything left null falls back to the ambient [PhoneFieldScope], so an app
/// configures labels and colors once instead of on every screen.
class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.phoneFieldController,
    this.onPhoneChanged,
    this.onCountryChanged,
    this.label = "Telefon",
    this.validator,
    this.focusNode,
    this.countryIsoCodes = const ["TR"],
    this.favoriteCountryIsoCodes,
    this.hintText,
    this.labels,
    this.fieldTheme,
    this.pickerTheme,
    this.labelStyle,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autovalidateMode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.countryPicker,
  });

  final PhoneFieldController phoneFieldController;
  final void Function(String)? onPhoneChanged;
  final void Function(PhoneCountryData)? onCountryChanged;
  final String? Function(String?)? validator;
  final String label;
  final FocusNode? focusNode;
  final String? hintText;

  /// Countries the user may pick from. An empty list means every country.
  final List<String> countryIsoCodes;

  /// Pinned above the alphabetical list under the "popular" header.
  final List<String>? favoriteCountryIsoCodes;

  final PhoneFieldLabels? labels;
  final PhoneFieldTheme? fieldTheme;
  final PhoneCountryPickerTheme? pickerTheme;
  final TextStyle? labelStyle;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  /// Replaces the built-in bottom sheet when a screen needs its own picker.
  final Future<PhoneCountryData?> Function(
    BuildContext context,
    List<PhoneCountryData> countries,
    PhoneCountryData? selected,
  )? countryPicker;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  late List<PhoneCountryData> _countries;
  PhoneInputFormatter? _formatter;

  @override
  void initState() {
    super.initState();
    _countries = PhoneCountries.resolve(widget.countryIsoCodes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureSelectionIsAllowed();
  }

  @override
  void didUpdateWidget(PhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryIsoCodes != widget.countryIsoCodes) {
      _countries = PhoneCountries.resolve(widget.countryIsoCodes);
      _ensureSelectionIsAllowed();
    }
  }

  /// A controller can hold a country this field does not offer (its default, or
  /// one left over from another screen); snap it to the first allowed country
  /// so the trigger never shows something the picker cannot produce.
  void _ensureSelectionIsAllowed() {
    if (_countries.isEmpty) return;
    final selected = widget.phoneFieldController.selectedCountry;
    if (selected != null &&
        _countries.any((c) => c.isoCode == selected.isoCode)) {
      return;
    }
    final scopeDefault = PhoneCountries.byIsoCode(
      PhoneFieldScope.maybeOf(context)?.defaultCountryIsoCode,
    );
    final fallback = scopeDefault != null &&
            _countries.any((c) => c.isoCode == scopeDefault.isoCode)
        ? scopeDefault
        : _countries.first;
    // The controller notifies its listeners, so this cannot run during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.phoneFieldController.country = fallback;
    });
  }

  PhoneInputFormatter _formatterFor(PhoneCountryData? country) {
    final iso = country?.isoCode;
    if (_formatter?.defaultCountryCode != iso) {
      _formatter = PhoneInputFormatter(
        defaultCountryCode: iso,
        shouldCorrectNumber: false,
      );
    }
    return _formatter!;
  }

  Future<void> _openPicker(PhoneCountryData? selected) async {
    FocusScope.of(context).unfocus();
    final scope = PhoneFieldScope.maybeOf(context);
    final picked = await (widget.countryPicker?.call(
          context,
          _countries,
          selected,
        ) ??
        showPhoneCountryPicker(
          context,
          countries: _countries,
          favoriteCountryIsoCodes: widget.favoriteCountryIsoCodes ??
              scope?.favoriteCountryIsoCodes ??
              const [],
          selectedCountry: selected,
          labels: widget.labels,
          theme: widget.pickerTheme,
        ));
    if (picked == null || !mounted) return;
    widget.phoneFieldController.country = picked;
    widget.onCountryChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final scope = PhoneFieldScope.maybeOf(context);
    final style =
        widget.fieldTheme ?? scope?.fieldTheme ?? const PhoneFieldTheme();

    return ValueListenableBuilder<PhoneCountryData?>(
      valueListenable: widget.phoneFieldController.countryController,
      builder: (context, country, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            if (widget.label.isNotEmpty)
              Text(widget.label, style: widget.labelStyle ?? style.labelStyle),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CountryTrigger(
                    country: country,
                    style: style,
                    enabled: widget.enabled && !widget.readOnly,
                    onTap: () => _openPicker(country),
                  ),
                  SizedBox(width: style.gap),
                  Expanded(
                    child: TextFormField(
                      controller: widget.phoneFieldController.phoneController,
                      focusNode: widget.focusNode,
                      validator: widget.validator,
                      autovalidateMode: widget.autovalidateMode,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      autofocus: widget.autofocus,
                      keyboardType: TextInputType.phone,
                      textInputAction: widget.textInputAction,
                      onChanged: widget.onPhoneChanged,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      inputFormatters: [_formatterFor(country)],
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: widget.hintText ?? country?.nationalMask,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CountryTrigger extends StatelessWidget {
  const _CountryTrigger({
    required this.country,
    required this.style,
    required this.enabled,
    required this.onTap,
  });

  final PhoneCountryData? country;
  final PhoneFieldTheme style;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final radius = BorderRadius.circular(style.triggerBorderRadius);
    final borderColor = style.triggerBorderColor ??
        theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
        colors.outline.withValues(alpha: 0.3);

    return Semantics(
      button: true,
      label: country?.displayName,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: style.fieldHeight ?? 0),
        child: Material(
          color: style.triggerColor ?? theme.inputDecorationTheme.fillColor,
          borderRadius: radius,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: radius,
            child: Container(
              padding: style.triggerPadding,
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (style.showFlag && country != null)
                    Text(
                      country!.flagEmoji,
                      style: TextStyle(fontSize: style.flagSize),
                    ),
                  if (style.showFlag && style.showDialCode)
                    const SizedBox(width: 6),
                  if (style.showDialCode)
                    Text(
                      country?.dialCode ?? '',
                      style: style.dialCodeStyle ??
                          theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  Icon(
                    style.chevronIcon,
                    size: 18,
                    color: colors.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
