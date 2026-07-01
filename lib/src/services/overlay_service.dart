import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_core/axii_core.dart';

class OverlayService {
  static Future<void> showSnackbarcContent(
    Widget content, {
    BuildContext? context,
    Color? backgroundColor,
    SnackBarBehavior? behavior,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    Duration? duration,
  }) async {
    try {
      removeSnackbar();
      ScaffoldMessenger.of(context ?? globalContext!).showSnackBar(
        SnackBar(
          content: content,
          duration: duration ?? const Duration(seconds: 2),
          backgroundColor: backgroundColor,
          behavior: behavior ?? SnackBarBehavior.floating,
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: margin ?? const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      printIfDebug("Error showing snackbar: $e");
    }
  }

  static Future<void> showErrorSnackbar({
    required String message,
    BuildContext? context,
    Color? backgroundColor,
  }) async {
    await showSnackbarcContent(
      Row(
        spacing: 8,
        children: [
          Icon(
            Icons.error_outline,
            color: (context ?? globalContext)?.colorScheme.onError,
          ),
          Expanded(
            child: AutoSizeText(
              message,
              presetFontSizes: 16.to<double>(10),
              style: TextStyles.regular16.copyWith(
                color: (context ?? globalContext!).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
      context: context,
      backgroundColor:
          backgroundColor ?? (context ?? globalContext!).colorScheme.error,
      behavior: SnackBarBehavior.floating,
    );
  }

  static Future<void> showSuccessSnackbar({
    required String message,
    BuildContext? context,
    Color? backgroundColor,
  }) async {
    await showSnackbarcContent(
      Row(
        spacing: 8,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: (context ?? globalContext)?.colorScheme.onPrimary,
          ),
          Expanded(
            child: AutoSizeText(
              message,
              presetFontSizes: 16.to<double>(10),
              style: TextStyles.regular16.copyWith(
                color: (context ?? globalContext!).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      context: context,
      backgroundColor:
          backgroundColor ?? (context ?? globalContext)?.colorScheme.primary,
      behavior: SnackBarBehavior.floating,
    );
  }

  static Future<void> showNormalDialog(
    Widget content, {
    BuildContext? context,
    bool barrierDismissible = true,
    Color? backgroundColor,
    EdgeInsets? padding,
  }) async {
    await showDialog(
      context: context ?? globalContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: backgroundColor,
      builder: (context) => Dialog(insetPadding: padding, child: content),
    );
  }

  static void removeSnackbar({BuildContext? context}) {
    ScaffoldMessenger.of(context ?? globalContext!).hideCurrentSnackBar();
  }
}
