import 'package:flutter/material.dart';
import 'package:flutter_project_core/src/extensions/context_extensions.dart';
import 'package:flutter_project_core/src/theme/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.focusNode,
    this.hint,
    this.isPassword = false,
    this.maxLines,
    this.maxLength,
    this.minLines = 1,
    this.afterValidation,
    this.isEnabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });
  final TextEditingController controller;
  final String? label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final Function? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? hint;
  final bool isEnabled;
  final bool isPassword;
  final int? maxLines;
  final int? maxLength;
  final int minLines;
  final AutovalidateMode? autovalidateMode;
  final Function(bool?)? afterValidation;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (widget.label != null) Text(widget.label!),
        TextFormField(
          controller: widget.controller,
          autovalidateMode: widget.autovalidateMode,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          maxLines: widget.maxLines ?? (widget.obscureText ? 1 : null),
          focusNode: widget.focusNode,
          maxLength: widget.maxLength,
          enabled: widget.isEnabled,
          onFieldSubmitted: (value) => widget.onFieldSubmitted?.call(),
          decoration: InputDecoration(
            counterText: "",
            hintText: widget.hint,
            hintStyle: TextStyles.regular14.copyWith(
              color: context.colorScheme.outline,
            ),
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: context.colorScheme.primary)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: context.colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
