import 'package:flutter/material.dart';
import 'package:flutter_project_core/core/extensions/context_extensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.borderSide,
    this.elevation,
    this.padding,
    this.borderShape,
    this.isActive = true,
    this.borderRadius,
  });

  final Function? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? color;
  final bool isActive;
  final double? borderRadius;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? borderShape;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (onPressed == null || !isActive) ? null : () => onPressed!(),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: color,
        elevation: elevation,
        padding: padding,
        minimumSize: Size(1, 1),
        shape:
            borderShape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              side: borderSide ?? BorderSide.none,
            ),
        fixedSize: Size(width ?? context.getWidth, height ?? 48),
      ),
      child: child,
    );
  }
}
