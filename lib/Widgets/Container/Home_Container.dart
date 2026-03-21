import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Helpers/app_colors.dart';
import '../../TextTheme/text_theme.dart';

class HomeContainer extends StatelessWidget {
  final String image;
  final String svg;
  final String name;

  const HomeContainer({
    super.key,
    required this.image,
    required this.svg,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {

    final AppColors appColors = Get.put(AppColors());
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: appColors.selectedColor.value,
          width: 0.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.opacity.withValues(alpha: 0.1),
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 0
          ),
        ],
      ),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          svg.isEmpty ?Image.asset(image,height: 40,width: 40,) : SvgPicture.string(svg),
          Text(name,style: Theme.of(context).textTheme.body2SemiBold.copyWith(color: AppColors.text),),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
