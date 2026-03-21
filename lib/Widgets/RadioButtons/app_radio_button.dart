import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Helpers/app_colors.dart';
import 'app_radio_button_controller.dart';

class AppRadioButton extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  const AppRadioButton({super.key, required this.items, required this.selectedIndex});

  @override
  State<AppRadioButton> createState() => _AppRadioButtonState();
}

class _AppRadioButtonState extends State<AppRadioButton> {

  final AppColors appColors = Get.put(AppColors());
  AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());

  @override
  void initState() {
    appRadioButtonController.selectedIndexGender.value = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        child: Row(
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
                          appRadioButtonController.selectedIndexGender.value = index;
                          appRadioButtonController.selectedRelation.value = index;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: appRadioButtonController.selectedIndexGender.value == index ? appColors.selectedColor.value : appColors.selectedColor.value)
                                ),
                                alignment: Alignment.center,
                                child: appRadioButtonController.selectedIndexGender.value == index
                                    ? CircleAvatar(
                                  radius: 5,
                                  backgroundColor: appColors.selectedColor.value,
                                )
                                    : null,
                              ),
                              Text(
                                widget.items[index],
                                style: Theme.of(context).textTheme.bodyRegular.copyWith(
                                    color: appColors.selectedColor.value
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
