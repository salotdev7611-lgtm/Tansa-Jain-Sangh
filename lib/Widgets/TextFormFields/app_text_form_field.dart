import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final int? maxLine;   // null = auto expand
  final int? minLine;   // initial height
  final int? maxLength;
  final Widget? suffixIcon;
  final Color? color;
  final String? Function(String?)? validator;
  final VoidCallback? datePickerOnTap;

  const AppTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType,
    this.maxLine,
    this.minLine,
    this.maxLength,
    this.suffixIcon,
    this.color, this.validator, this.datePickerOnTap,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.multiline,

      minLines: widget.minLine ?? 1,
      maxLines: widget.maxLine, // null = auto expand (NO SCROLL)

      maxLength: widget.maxLength,

      style: Theme.of(context)
          .textTheme
          .body2Regular
          .copyWith(color: AppColors.text),

      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onTap: widget.datePickerOnTap,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        filled: widget.color != null,
        fillColor: widget.color,
        labelText: widget.labelText,
        labelStyle: Theme.of(context)
            .textTheme
            .body2Regular
            .copyWith(color: AppColors.text),
        suffixIcon: widget.suffixIcon ?? const SizedBox.shrink(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.text),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.text),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.red),
        ),
        errorStyle: Theme.of(context)
            .textTheme
            .body2Regular
            .copyWith(color: AppColors.red),
      ),
    );
  }
}
