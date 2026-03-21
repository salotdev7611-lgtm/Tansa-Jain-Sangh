import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Helpers/app_colors.dart';
import 'package:get/get.dart';
class OutlineButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final String icon;
  final Color? borderColor;
  final TextStyle? textStyle;
  const OutlineButton({super.key, required this.onTap, required this.text, required this.icon, this.textStyle, this.borderColor});

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {

  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor ?? appColors.selectedColor.value),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              SvgPicture.string(widget.icon,colorFilter: ColorFilter.mode(widget.borderColor ?? appColors.selectedColor.value, BlendMode.srcIn),),
              Text(
                widget.text,
                style: widget.textStyle ?? Theme.of(context).textTheme.body1Regular.copyWith(color: widget.borderColor ?? appColors.selectedColor.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
