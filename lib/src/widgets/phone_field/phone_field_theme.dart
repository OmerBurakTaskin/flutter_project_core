import 'package:flutter/material.dart';

/// Every user facing string the phone field and its country picker can show.
/// The package ships English defaults; apps override them with their own l10n.
@immutable
class PhoneFieldLabels {
  const PhoneFieldLabels({
    this.pickerTitle = 'Select Country',
    this.searchHint = 'Search',
    this.popularSection = 'POPULAR',
    this.allCountriesSection = 'ALL COUNTRIES',
    this.emptyResult = 'No country found',
  });

  final String pickerTitle;
  final String searchHint;
  final String popularSection;
  final String allCountriesSection;
  final String emptyResult;

  PhoneFieldLabels copyWith({
    String? pickerTitle,
    String? searchHint,
    String? popularSection,
    String? allCountriesSection,
    String? emptyResult,
  }) {
    return PhoneFieldLabels(
      pickerTitle: pickerTitle ?? this.pickerTitle,
      searchHint: searchHint ?? this.searchHint,
      popularSection: popularSection ?? this.popularSection,
      allCountriesSection: allCountriesSection ?? this.allCountriesSection,
      emptyResult: emptyResult ?? this.emptyResult,
    );
  }
}

/// Visuals of the country trigger sitting left of the number input.
/// Null means "take it from the ambient [ThemeData]".
@immutable
class PhoneFieldTheme {
  const PhoneFieldTheme({
    this.triggerColor,
    this.triggerBorderColor,
    this.triggerBorderRadius = 10,
    this.triggerPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.fieldHeight,
    this.gap = 12,
    this.labelStyle,
    this.dialCodeStyle,
    this.flagSize = 22,
    this.showFlag = true,
    this.showDialCode = true,
    this.chevronIcon = Icons.expand_more,
  });

  final Color? triggerColor;
  final Color? triggerBorderColor;
  final double triggerBorderRadius;
  final EdgeInsetsGeometry triggerPadding;

  /// Null lets the trigger match whatever height the input decoration produces.
  final double? fieldHeight;
  final double gap;
  final TextStyle? labelStyle;
  final TextStyle? dialCodeStyle;
  final double flagSize;
  final bool showFlag;
  final bool showDialCode;
  final IconData chevronIcon;

  PhoneFieldTheme copyWith({
    Color? triggerColor,
    Color? triggerBorderColor,
    double? triggerBorderRadius,
    EdgeInsetsGeometry? triggerPadding,
    double? fieldHeight,
    double? gap,
    TextStyle? labelStyle,
    TextStyle? dialCodeStyle,
    double? flagSize,
    bool? showFlag,
    bool? showDialCode,
    IconData? chevronIcon,
  }) {
    return PhoneFieldTheme(
      triggerColor: triggerColor ?? this.triggerColor,
      triggerBorderColor: triggerBorderColor ?? this.triggerBorderColor,
      triggerBorderRadius: triggerBorderRadius ?? this.triggerBorderRadius,
      triggerPadding: triggerPadding ?? this.triggerPadding,
      fieldHeight: fieldHeight ?? this.fieldHeight,
      gap: gap ?? this.gap,
      labelStyle: labelStyle ?? this.labelStyle,
      dialCodeStyle: dialCodeStyle ?? this.dialCodeStyle,
      flagSize: flagSize ?? this.flagSize,
      showFlag: showFlag ?? this.showFlag,
      showDialCode: showDialCode ?? this.showDialCode,
      chevronIcon: chevronIcon ?? this.chevronIcon,
    );
  }
}

/// Visuals of the country bottom sheet. Null means "take it from [ThemeData]".
@immutable
class PhoneCountryPickerTheme {
  const PhoneCountryPickerTheme({
    this.backgroundColor,
    this.rowColor,
    this.selectedRowColor,
    this.dividerColor,
    this.searchFieldColor,
    this.accentColor,
    this.titleStyle,
    this.sectionHeaderStyle,
    this.countryNameStyle,
    this.dialCodeStyle,
    this.heightFactor = 0.85,
    this.cornerRadius = 16,
    this.rowHeight = 52,
    this.sectionHeaderHeight = 32,
    this.showDragHandle = true,
    this.showSearchField = true,
    this.showAlphabetIndex = true,
    this.showDialCodeBadge = true,
  });

  final Color? backgroundColor;
  final Color? rowColor;
  final Color? selectedRowColor;
  final Color? dividerColor;
  final Color? searchFieldColor;
  final Color? accentColor;
  final TextStyle? titleStyle;
  final TextStyle? sectionHeaderStyle;
  final TextStyle? countryNameStyle;
  final TextStyle? dialCodeStyle;

  /// Share of the screen height the sheet takes.
  final double heightFactor;
  final double cornerRadius;
  final double rowHeight;
  final double sectionHeaderHeight;
  final bool showDragHandle;
  final bool showSearchField;
  final bool showAlphabetIndex;
  final bool showDialCodeBadge;

  PhoneCountryPickerTheme copyWith({
    Color? backgroundColor,
    Color? rowColor,
    Color? selectedRowColor,
    Color? dividerColor,
    Color? searchFieldColor,
    Color? accentColor,
    TextStyle? titleStyle,
    TextStyle? sectionHeaderStyle,
    TextStyle? countryNameStyle,
    TextStyle? dialCodeStyle,
    double? heightFactor,
    double? cornerRadius,
    double? rowHeight,
    double? sectionHeaderHeight,
    bool? showDragHandle,
    bool? showSearchField,
    bool? showAlphabetIndex,
    bool? showDialCodeBadge,
  }) {
    return PhoneCountryPickerTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      rowColor: rowColor ?? this.rowColor,
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      dividerColor: dividerColor ?? this.dividerColor,
      searchFieldColor: searchFieldColor ?? this.searchFieldColor,
      accentColor: accentColor ?? this.accentColor,
      titleStyle: titleStyle ?? this.titleStyle,
      sectionHeaderStyle: sectionHeaderStyle ?? this.sectionHeaderStyle,
      countryNameStyle: countryNameStyle ?? this.countryNameStyle,
      dialCodeStyle: dialCodeStyle ?? this.dialCodeStyle,
      heightFactor: heightFactor ?? this.heightFactor,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      rowHeight: rowHeight ?? this.rowHeight,
      sectionHeaderHeight: sectionHeaderHeight ?? this.sectionHeaderHeight,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      showSearchField: showSearchField ?? this.showSearchField,
      showAlphabetIndex: showAlphabetIndex ?? this.showAlphabetIndex,
      showDialCodeBadge: showDialCodeBadge ?? this.showDialCodeBadge,
    );
  }
}

/// App wide defaults for every [PhoneField] below it. Wrapping the app once
/// keeps localized labels and brand colors out of the individual screens.
class PhoneFieldScope extends InheritedWidget {
  const PhoneFieldScope({
    super.key,
    required super.child,
    this.labels,
    this.fieldTheme,
    this.pickerTheme,
    this.favoriteCountryIsoCodes,
    this.defaultCountryIsoCode,
  });

  final PhoneFieldLabels? labels;
  final PhoneFieldTheme? fieldTheme;
  final PhoneCountryPickerTheme? pickerTheme;

  /// Pinned to the top of the picker under the "popular" header.
  final List<String>? favoriteCountryIsoCodes;
  final String? defaultCountryIsoCode;

  static PhoneFieldScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PhoneFieldScope>();
  }

  @override
  bool updateShouldNotify(PhoneFieldScope oldWidget) {
    return labels != oldWidget.labels ||
        fieldTheme != oldWidget.fieldTheme ||
        pickerTheme != oldWidget.pickerTheme ||
        favoriteCountryIsoCodes != oldWidget.favoriteCountryIsoCodes ||
        defaultCountryIsoCode != oldWidget.defaultCountryIsoCode;
  }
}
