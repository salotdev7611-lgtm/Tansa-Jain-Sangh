import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

// ignore: must_be_immutable
class AppCheckBox extends StatefulWidget {
  bool isChecked;
  final VoidCallback onTap;
  AppCheckBox({super.key, required this.isChecked, required this.onTap});

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      child: GestureDetector(
        onTap: widget.onTap,
          // widget.onTap;
          // print("member check");
          // print("check this");
          // setState(() {
          //   widget.isChecked = !widget.isChecked;
          // });
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.isChecked ? appColors.selectedColor.value : AppColors.white,
            border: Border.all(color: appColors.selectedColor.value),
          ),
          child: widget.isChecked ? SvgPicture.string(AppSvgs.checkDone,colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),) : null ,
        ),
      ),
    );
  }
}
