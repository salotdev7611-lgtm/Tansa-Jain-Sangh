import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Helpers/app_colors.dart';
import 'package:get/get.dart';
class ActiveIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final String icon;
  final TextStyle? textStyle;
  final bool? isPost;
  const ActiveIconButton({super.key, required this.onTap, required this.text, this.textStyle, required this.icon, this.isPost = false});

  @override
  State<ActiveIconButton> createState() => _ActiveIconButtonState();
}

class _ActiveIconButtonState extends State<ActiveIconButton> {

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            color: appColors.selectedColor.value,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              if(widget.isPost!)SvgPicture.string(widget.icon,colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),
              if(!widget.isPost!)SvgPicture.string(widget.icon,colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),
              Text(
                widget.text,
                style: widget.textStyle ?? Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),
              ),
              SizedBox(width: 4,)
            ],
          ),
        ),
      ),
    );
  }
}
