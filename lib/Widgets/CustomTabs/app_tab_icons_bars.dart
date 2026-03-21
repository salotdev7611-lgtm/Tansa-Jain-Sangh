import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/ManagePost/Manage_Feed_Controller.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Helpers/app_colors.dart';

class AppTabIconsBars extends StatefulWidget {
  final List<String> items;
  final List<String> icons;
  final int selectedIndex;
  final Function(int index) onTap;
  const AppTabIconsBars({super.key, required this.items, required this.icons, required this.selectedIndex, required this.onTap});

  @override
  State<AppTabIconsBars> createState() => _AppTabIconsBarsState();
}

class _AppTabIconsBarsState extends State<AppTabIconsBars> {

  final AppColors appColors = Get.put(AppColors());
  AppTabBarIconsController appTabBarIconsController = Get.put(AppTabBarIconsController());
  ManageFeedController manageFeedController = Get.put(ManageFeedController());


  @override
  void initState() {
    // appTabBarIconsController.selectedIndex.value = widget.selectedIndex;
    // appTabBarIconsController.selectedTwoIndex.value = widget.selectedIndex;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                itemBuilder: (context,index){
                  return Obx(
                        () => GestureDetector(

                      onTap: () {
                        // appTabBarIconsController.selectedIndex.value = index;
                     // appTabBarIconsController.selectedTwoIndex.value = index;
                     //    print("appTabBarIconsController.selectedTwoIndex.value ${appTabBarIconsController.selectedTwoIndex.value}");
                        widget.onTap(index);
                      },


                          child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: widget.selectedIndex == index ? appColors.selectedColor.value : AppColors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: widget.selectedIndex == index ? appColors.selectedColor.value : appColors.selectedColor.value)
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            child: Row(
                              spacing: 10,
                              children: [
                                SvgPicture.string(
                                  widget.icons[index],
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      widget.selectedIndex == index
                                          ? AppColors.white
                                          : appColors.selectedColor.value,
                                      BlendMode.srcIn
                                  ),
                                ),
                                Text(
                                  widget.items[index],
                                  style: Theme.of(context).textTheme.bodyRegular.copyWith(
                                      color: widget.selectedIndex == index ? AppColors.white : appColors.selectedColor.value
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
