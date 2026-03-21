import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppTabBars extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final Function(int index) onTap;
  const AppTabBars({super.key, required this.items, required this.selectedIndex, required this.onTap,});

  @override
  State<AppTabBars> createState() => _AppTabBarsState();
}

class _AppTabBarsState extends State<AppTabBars> {

  final AppColors appColors = Get.put(AppColors());
  AppTabBarController appTabBarController = Get.put(AppTabBarController());
  AddEventController addEventController = Get.put(AddEventController());

  @override
  void initState() {
    appTabBarController.selectedIndex.value = widget.selectedIndex;
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
              padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                itemBuilder: (context,index){
                  return Obx(() => GestureDetector(
                    onTap: () {
                      // appTabBarIconsController.selectedIndex.value = index;
                      // appTabBarIconsController.selectedTwoIndex.value = index;
                      //    print("appTabBarIconsController.selectedTwoIndex.value ${appTabBarIconsController.selectedTwoIndex.value}");
                      widget.onTap(index);
                    },
                      // onTap: () {
                      //   appTabBarController.selectedIndex.value = index;
                      //   print(appTabBarController.selectedIndex);
                      //   if(appTabBarController.selectedIndex.value == 0){
                      //     addEventController.eventGet(status: 'upcoming');
                      //   }
                      //   else if(appTabBarController.selectedIndex.value == 1){
                      //     addEventController.eventGet(status: 'live');
                      //   }
                      //   else{
                      //     addEventController.eventGet(status: 'past');
                      //   }
                      // },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: appTabBarController.selectedIndex.value == index ? appColors.selectedColor.value : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: appTabBarController.selectedIndex.value == index ? appColors.selectedColor.value : AppColors.white)
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            child: Text(
                              widget.items[index],
                              style: Theme.of(context).textTheme.bodyRegular.copyWith(
                                color: appTabBarController.selectedIndex.value == index ? AppColors.white : appColors.selectedColor.value
                              ),
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
