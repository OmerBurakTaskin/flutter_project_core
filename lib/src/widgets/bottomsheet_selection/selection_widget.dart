import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/widget_extensions.dart';
import 'package:flutter_project_core/src/widgets/bottomsheet_selection/selection_bottom_sheet.dart';

class CreateSaloonSelectionWidget<T> extends StatelessWidget {
  const CreateSaloonSelectionWidget({
    super.key,
    required this.label,
    required this.onSelected,
    required this.hintText,
    required this.items,
    this.selectedItem,
    this.isActive = true,
    this.bottomSheetTitle,
  });
  final String label;
  final String hintText;
  final bool isActive;
  final Function(T) onSelected;
  final List<T> items;
  final T? selectedItem;
  final String? bottomSheetTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(label),
        Container(
          width: double.infinity,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(hintText), Icon(Icons.arrow_drop_down_rounded)],
          ),
        ).asGestureDetector(
          onTap: isActive == true
              ? () => showSelectionBottomSheet<T>(
                    context: context,
                    items: items,
                    onSelected: onSelected,
                    selectedItem: selectedItem,
                    title: bottomSheetTitle,
                  )
              : () {},
        ),
      ],
    );
  }
}
