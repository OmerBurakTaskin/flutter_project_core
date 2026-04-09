import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';
import 'package:flutter_project_core/src/extensions/widget_extensions.dart';
import 'package:flutter_project_core/src/widgets/bottomsheet_selection/selection_bottom_sheet.dart';

class CustomSelectionWidget<T> extends StatelessWidget {
  const CustomSelectionWidget(
      {super.key,
      this.label,
      this.hintText,
      required this.onSelected,
      required this.items,
      this.selectedItem,
      this.isActive = true,
      this.bottomSheetTitle,
      this.borderRadius = 16,
      this.customArrow,
      this.borderColor,
      this.backgroundColor,
      this.width});
  final String? label;
  final String? hintText;
  final bool isActive;
  final Function(T) onSelected;
  final List<T> items;
  final T? selectedItem;
  final String? bottomSheetTitle;
  final double? width;
  final Color? borderColor;
  final double borderRadius;
  final Widget? customArrow;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null) Text(label!),
        Container(
          width: width,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal:borderRadius),
          decoration: BoxDecoration(
            color: this.backgroundColor ?? Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor ?? Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hintText != null) Text(hintText!) else SizedBox.shrink(),
              customArrow ?? Icon(Icons.arrow_drop_down_rounded)
            ],
          ),
        ).asGestureDetector(
          onTap: isActive == true
              ? () {
                  context.unfocusKeyboard();
                  showSelectionBottomSheet<T>(
                    context: context,
                    items: items,
                    onSelected: onSelected,
                    selectedItem: selectedItem,
                    title: bottomSheetTitle,
                  );
                }
              : () {},
        ),
      ],
    );
  }
}
