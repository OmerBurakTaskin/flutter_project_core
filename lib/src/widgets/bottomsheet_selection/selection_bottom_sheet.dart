import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';
import 'package:flutter_project_core/src/extensions/widget_extensions.dart';
import 'package:flutter_project_core/src/theme/app_text_styles.dart';

class SelectionBottomSheet<T> extends StatelessWidget {
  const SelectionBottomSheet({
    super.key,
    this.onSelected,
    required this.items,
    required this.scrollController,
    this.selectedItem,
    this.title,
  });
  final List<T> items;
  final Function(T)? onSelected;
  final ScrollController scrollController;
  final T? selectedItem;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title!,
                style: TextStyles.medium18.copyWith(
                  color: context.colorScheme.outlineVariant,
                ),
              ).paddingSymmetric(vertical: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.toString()),
                    trailing: selectedItem == item
                        ? Icon(
                            Icons.check_circle,
                            color: context.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      onSelected?.call(item);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showSelectionBottomSheet<T>({
  required BuildContext context,
  required List<T> items,
  required Function(T)? onSelected,
  T? selectedItem,
  String? title,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SelectionBottomSheet<T>(
        items: items,
        onSelected: onSelected,
        scrollController: ScrollController(),
        title: title,
      );
    },
  );
}
