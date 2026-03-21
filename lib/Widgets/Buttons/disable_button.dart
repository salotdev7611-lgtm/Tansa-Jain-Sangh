import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../Helpers/app_colors.dart';
import 'package:get/get.dart';
class DisableButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;
  const DisableButton({super.key, required this.onTap, required this.text, this.textStyle});

  @override
  State<DisableButton> createState() => _DisableButtonState();
}

class _DisableButtonState extends State<DisableButton> {
  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: appColors.selectedColor.value.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          child: Text(
            widget.text,
            style: widget.textStyle ?? Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
