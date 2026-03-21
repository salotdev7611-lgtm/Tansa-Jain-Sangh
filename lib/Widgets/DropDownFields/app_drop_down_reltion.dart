import 'package:family_app/DesignScreen/HS/UpdateProfile/UpdateProfileController.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class AppDropDownRelation extends StatefulWidget {
  const AppDropDownRelation({super.key, required this.relationController});

  final SingleValueDropDownController relationController;

  @override
  State<AppDropDownRelation> createState() => _AppDropDownRelationState();
}

class _AppDropDownRelationState extends State<AppDropDownRelation> {

  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());
  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      controller: widget.relationController,
      dropdownRadius: 5,
      textFieldDecoration: InputDecoration(
        labelText: "Select Relation",
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
      dropDownList: [
        DropDownValueModel(
          name: "Grand Mother",
          value: "Grand Mother",
        ),
        DropDownValueModel(
          name: "Grand Father",
          value: "Grand Father",
        ),
        DropDownValueModel(
          name: "Mother",
          value: "Mother",
        ),
        DropDownValueModel(
          name: "Father",
          value: "Father",
        ),
        DropDownValueModel(
          name: "Daughter",
          value: "Daughter",
        ),
        DropDownValueModel(
          name: "Son",
          value: "Son",
        ),
        DropDownValueModel(
          name: "Son in Law",
          value: "Son in Law",
        ),
        DropDownValueModel(
          name: "Daughter in Law",
          value: "Daughter in Law",
        ),
        DropDownValueModel(
          name: "Sister in Law",
          value: "Sister in Law",
        ),
        DropDownValueModel(
          name: "Brother in Law",
          value: "Brother in Law",
        ),
        DropDownValueModel(
          name: "Uncle",
          value: "Uncle",
        ),
        DropDownValueModel(
          name: "Aunty",
          value: "Aunty",
        ),
      ],
    );
  }
}
