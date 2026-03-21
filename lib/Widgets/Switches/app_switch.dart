import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Switches/app_switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({super.key});

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {

  final AppColors appColors = Get.put(AppColors());
  AppSwitchController appSwitchController = Get.put(AppSwitchController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16,),
      child: GestureDetector(
        onTap: () {
          appSwitchController.changeBool(!appSwitchController.isEnabled.value);
        },
        child: Obx(
          () => Row(
            spacing: 5,
            children: [
              Text(
                appSwitchController.isEnabled.value ? "Gujarati" : "English",
                style: Theme.of(context).textTheme.body2SemiBold.copyWith(color: appColors.selectedColor.value),
              ),
              FlutterSwitch(
                width: 34,
                  height: 18,
                  padding: 1,
                  toggleSize: 17,
                  inactiveColor: AppColors.grey.withValues(alpha: 0.2),
                  activeColor: appColors.selectedColor.value.withValues(alpha: 0.2),
                  inactiveToggleColor: AppColors.grey,
                  activeToggleColor: appColors.selectedColor.value,
                  borderRadius: 50,
                  value: appSwitchController.isEnabled.value,
                  onToggle: appSwitchController.changeBool,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
