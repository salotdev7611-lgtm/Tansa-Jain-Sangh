import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Helpers/app_colors.dart';
import 'app_radio_button_controller.dart';

class AppRadioButtonMarital extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final Function(int index, String value) onChanged;

  const AppRadioButtonMarital({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<AppRadioButtonMarital> createState() => _AppRadioButtonMaritalState();
}


class _AppRadioButtonMaritalState extends State<AppRadioButtonMarital> {

  final AppColors appColors = Get.put(AppColors());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());

  @override
  void initState() {
    appRadioButtonController.selectedIndexMarital.value = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Obx(
                () => GestureDetector(
              onTap: () {
                appRadioButtonController.selectedIndexMarital.value = index;

                // 🔥 SEND VALUE TO PARENT
                widget.onChanged(index, widget.items[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appColors.selectedColor.value,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: appRadioButtonController.selectedIndexMarital.value == index
                          ? CircleAvatar(
                        radius: 5,
                        backgroundColor: appColors.selectedColor.value,
                      )
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.items[index],
                      style: Theme.of(context)
                          .textTheme
                          .bodyRegular
                          .copyWith(color: appColors.selectedColor.value),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
