import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../custom_button.dart';
import '../../core/extensions/context_extensions.dart';

class ConnectionLostDialog extends StatelessWidget {
  const ConnectionLostDialog({super.key, this.onPressed});

  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Container(
          height: 403,
          width: min(320, context.getWidth * 0.9),
          decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Image.asset(
                  "assets/images/wifi_signal_icon.png",
                  height: 120,
                ),
                SizedBox(height: 16),
                Text("No Internet Connection", style: TextStyles.medium20),
                Text(
                  "Please check your internet connection and try again.",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyles.regular16
                      .copyWith(color: context.colorScheme.onPrimary),
                ),
                SizedBox(height: 16),
                CustomButton(
                    onPressed: () => onPressed?.call() ?? _onPressed(),
                    borderRadius: 12,
                    color: context.colorScheme.primary,
                    height: 48,
                    width: 272,
                    child: Text("Try Again",
                        style: TextStyles.semiBold16
                            .copyWith(color: context.colorScheme.primary)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() {}
}

Future<void> showConnectionLostDialog(BuildContext context) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.grey.withAlpha(80),
      builder: (context) => ConnectionLostDialog());
}
