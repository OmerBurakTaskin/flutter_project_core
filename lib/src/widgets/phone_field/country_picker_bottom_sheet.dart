import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_country.dart';
import 'package:flutter_project_core/src/widgets/phone_field/phone_field_theme.dart';

/// Opens the country picker and resolves with the pick, or null when dismissed.
Future<PhoneCountryData?> showPhoneCountryPicker(
  BuildContext context, {
  List<PhoneCountryData>? countries,
  List<String> countryIsoCodes = const [],
  List<String> favoriteCountryIsoCodes = const [],
  PhoneCountryData? selectedCountry,
  PhoneFieldLabels? labels,
  PhoneCountryPickerTheme? theme,
}) {
  final scope = PhoneFieldScope.maybeOf(context);
  final resolvedTheme = theme ?? scope?.pickerTheme ?? const PhoneCountryPickerTheme();
  final resolvedLabels = labels ?? scope?.labels ?? const PhoneFieldLabels();

  return showModalBottomSheet<PhoneCountryData>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: PhoneCountryPickerSheet(
        countries: countries ?? PhoneCountries.resolve(countryIsoCodes),
        favoriteCountryIsoCodes: favoriteCountryIsoCodes,
        selectedCountry: selectedCountry,
        labels: resolvedLabels,
        theme: resolvedTheme,
      ),
    ),
  );
}

class PhoneCountryPickerSheet extends StatefulWidget {
  const PhoneCountryPickerSheet({
    super.key,
    required this.countries,
    this.favoriteCountryIsoCodes = const [],
    this.selectedCountry,
    this.labels = const PhoneFieldLabels(),
    this.theme = const PhoneCountryPickerTheme(),
  });

  final List<PhoneCountryData> countries;
  final List<String> favoriteCountryIsoCodes;
  final PhoneCountryData? selectedCountry;
  final PhoneFieldLabels labels;
  final PhoneCountryPickerTheme theme;

  @override
  State<PhoneCountryPickerSheet> createState() =>
      _PhoneCountryPickerSheetState();
}

sealed class _PickerItem {
  const _PickerItem();
}

class _SectionHeaderItem extends _PickerItem {
  const _SectionHeaderItem(this.label);
  final String label;
}

class _CountryItem extends _PickerItem {
  const _CountryItem(this.country);
  final PhoneCountryData country;
}

class _PhoneCountryPickerSheetState extends State<PhoneCountryPickerSheet> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late List<PhoneCountryData> _favorites;
  late List<_PickerItem> _browseItems;

  /// Letter to scroll offset in the browse list, feeding the A-Z index.
  final Map<String, double> _letterOffsets = {};
  double? _selectedOffset;

  String _query = '';

  @override
  void initState() {
    super.initState();
    _buildBrowseList();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void didUpdateWidget(PhoneCountryPickerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countries != widget.countries ||
        oldWidget.favoriteCountryIsoCodes != widget.favoriteCountryIsoCodes) {
      _buildBrowseList();
    }
  }

  /// Builds the non-search list and, in the same pass, the scroll offsets the
  /// A-Z index jumps to. Offsets stay correct only while row heights are fixed.
  void _buildBrowseList() {
    final allowed = {for (final c in widget.countries) c.isoCode: c};
    _favorites = widget.favoriteCountryIsoCodes
        .map((code) => allowed[code.toUpperCase()])
        .whereType<PhoneCountryData>()
        .toList();

    final items = <_PickerItem>[];
    _letterOffsets.clear();
    _selectedOffset = null;

    final headerHeight = widget.theme.sectionHeaderHeight;
    final rowHeight = widget.theme.rowHeight;
    var offset = 0.0;

    void addHeader(String label) {
      items.add(_SectionHeaderItem(label));
      offset += headerHeight;
    }

    void addCountry(PhoneCountryData country) {
      if (country.isoCode == widget.selectedCountry?.isoCode) {
        _selectedOffset ??= offset;
      }
      items.add(_CountryItem(country));
      offset += rowHeight;
    }

    if (_favorites.isNotEmpty) {
      addHeader(widget.labels.popularSection);
      _favorites.forEach(addCountry);
      addHeader(widget.labels.allCountriesSection);
    }

    String? currentLetter;
    for (final country in widget.countries) {
      final letter = country.displayName.isEmpty
          ? '#'
          : country.displayName[0].toUpperCase();
      if (letter != currentLetter) {
        currentLetter = letter;
        _letterOffsets[letter] = offset;
        addHeader(letter);
      }
      addCountry(country);
    }

    _browseItems = items;
  }

  /// Opening on the current pick saves scrolling through 200 countries.
  void _revealSelected() {
    final offset = _selectedOffset;
    if (offset == null || !_scrollController.hasClients) return;
    _scrollController.jumpTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  void _jumpToLetter(String letter) {
    final offset = _letterOffsets[letter];
    if (offset == null || !_scrollController.hasClients) return;
    _scrollController.jumpTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  List<_PickerItem> get _visibleItems {
    if (_query.trim().isEmpty) return _browseItems;
    return PhoneCountries.search(widget.countries, _query)
        .map<_PickerItem>(_CountryItem.new)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final style = widget.theme;

    final background = style.backgroundColor ?? colors.surface;
    final divider = style.dividerColor ?? theme.dividerColor;
    final accent = style.accentColor ?? colors.primary;
    final isSearching = _query.trim().isNotEmpty;
    final items = _visibleItems;

    return Container(
      height: MediaQuery.sizeOf(context).height * style.heightFactor,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(style.cornerRadius),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (style.showDragHandle)
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
            child: Text(
              widget.labels.pickerTitle,
              style: style.titleStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (style.showSearchField)
            _SearchField(
              controller: _searchController,
              hintText: widget.labels.searchHint,
              fillColor: style.searchFieldColor ?? colors.surfaceContainerLowest,
              borderColor: divider,
              onChanged: (value) => setState(() => _query = value),
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      widget.labels.emptyResult,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.outline,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        // Search results are one flat list, so the offsets the
                        // A-Z index relies on only hold in browse mode.
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.viewPaddingOf(context).bottom,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return switch (item) {
                            _SectionHeaderItem() => _SectionHeader(
                                label: item.label,
                                height: style.sectionHeaderHeight,
                                background: background,
                                textStyle: style.sectionHeaderStyle ??
                                    theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colors.outline,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            _CountryItem() => PhoneCountryRow(
                                country: item.country,
                                isSelected: item.country.isoCode ==
                                    widget.selectedCountry?.isoCode,
                                theme: style,
                                onTap: () =>
                                    Navigator.of(context).pop(item.country),
                              ),
                          };
                        },
                      ),
                      if (style.showAlphabetIndex &&
                          !isSearching &&
                          _letterOffsets.length > 1)
                        Positioned(
                          right: 2,
                          top: 0,
                          bottom: 0,
                          child: _AlphabetIndex(
                            letters: _letterOffsets.keys.toList(),
                            color: accent,
                            onLetterTap: _jumpToLetter,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class PhoneCountryRow extends StatelessWidget {
  const PhoneCountryRow({
    super.key,
    required this.country,
    required this.isSelected,
    required this.onTap,
    this.theme = const PhoneCountryPickerTheme(),
  });

  final PhoneCountryData country;
  final bool isSelected;
  final VoidCallback onTap;
  final PhoneCountryPickerTheme theme;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final colors = materialTheme.colorScheme;
    final accent = theme.accentColor ?? colors.primary;
    final divider = theme.dividerColor ?? materialTheme.dividerColor;
    final rowColor = theme.rowColor ?? materialTheme.cardColor;
    final selectedColor =
        theme.selectedRowColor ?? accent.withValues(alpha: 0.08);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: theme.rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : rowColor,
          border: Border(bottom: BorderSide(color: divider)),
        ),
        child: Row(
          children: [
            Text(country.flagEmoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                country.displayName,
                overflow: TextOverflow.ellipsis,
                // Selection has to win over a custom style, otherwise a
                // themed row loses the only cue that it is the current pick.
                style: (theme.countryNameStyle ??
                        materialTheme.textTheme.bodyMedium)
                    ?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? accent : null,
                ),
              ),
            ),
            if (theme.showDialCodeBadge) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? accent : divider,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  country.dialCode,
                  style: (theme.dialCodeStyle ??
                          materialTheme.textTheme.labelSmall)
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? colors.onPrimary : null,
                  ),
                ),
              ),
            ],
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_rounded, size: 18, color: accent),
            ],
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.fillColor,
    required this.borderColor,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hintText;
  final Color fillColor;
  final Color borderColor;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: colors.outline),
                prefixIcon: Icon(Icons.search, size: 20, color: colors.outline),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear,
                            size: 18, color: colors.outline),
                        onPressed: onClear,
                      ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    required this.height,
    required this.background,
    required this.textStyle,
  });

  final String label;
  final double height;
  final Color background;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(label, style: textStyle),
    );
  }
}

class _AlphabetIndex extends StatelessWidget {
  const _AlphabetIndex({
    required this.letters,
    required this.color,
    required this.onLetterTap,
  });

  final List<String> letters;
  final Color color;
  final ValueChanged<String> onLetterTap;

  @override
  Widget build(BuildContext context) {
    // A short sheet or a tall keyboard can leave less room than 26 letters
    // need, so the whole strip scales down instead of overflowing.
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: letters
              .map(
                (letter) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onLetterTap(letter),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 5,
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
