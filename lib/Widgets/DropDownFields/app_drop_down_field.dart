import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/UpdateProfile/UpdateProfileController.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class AppDropDownField extends StatefulWidget {
  const AppDropDownField({super.key, required this.profession});
  final SingleValueDropDownController profession;



  @override
  State<AppDropDownField> createState() => _AppDropDownFieldState();
}

class _AppDropDownFieldState extends State<AppDropDownField> {

  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());
  final AdminSettingController adminSettingController = Get.put(AdminSettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminSettingController.getProfession();
  }
  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      controller: widget.profession,
      dropdownRadius: 5,
      textFieldDecoration: InputDecoration(
        labelText: "Select Profession",
        labelStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.text),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.red),
        ),
      ),
        textStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
        listTextStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),
        listPadding: ListPadding(bottom: 5, top: 5),
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        clearOption: false,
        dropDownList: adminSettingController.professionList
    );
  }
}
