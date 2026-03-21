import 'dart:io';

import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/Add_Relation_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_field.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/Buttons/active_button.dart';
import '../../../Widgets/RadioButtons/app_radio_button.dart';

class WifeRelation extends StatefulWidget {
  const WifeRelation({super.key});

  @override
  State<WifeRelation> createState() => _WifeRelationState();
}

class _WifeRelationState extends State<WifeRelation> {

  final AddRelationController addRelationController = Get.put(AddRelationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Partner Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: addRelationController.wifeFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Obx(() => InkWell(
                        onTap: (){
                          // addRelationController.profileImagePicker();
                        },
                        child:Container(
                          height: 140,
                          width: 130,
                          decoration: BoxDecoration(
                            color: AppColors.text,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: addRelationController.profileImage.value.isNotEmpty
                                ? DecorationImage(
                              image: addRelationController.profileImage.value.startsWith("http")
                                  ? NetworkImage(addRelationController.profileImage.value)
                                  : FileImage(File(addRelationController.profileImage.value))
                              as ImageProvider,
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: addRelationController.profileImage.value.isEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.string(
                                AppSvgs.uploadImage1,
                                color: AppColors.white,
                              ),
                              Text(
                                "Upload User Profile",
                                style: Theme.of(context)
                                    .textTheme
                                    .body1Bold
                                    .copyWith(color: AppColors.white),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                              : null,
                        )
                    ),)
                ),
                Text("Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(child: AppTextFormField(labelText: "Name", controller: addRelationController.wifeName)),
                    Expanded(child: AppDropDownSurname(surname: addRelationController.wifeSurname,readOnly: true,)),
                  ],
                ),
                AppTextFormField(labelText: "Date Of Birth", controller: addRelationController.wifeDateOfBirth),
                AppTextFormField(labelText: "Death Date", controller: addRelationController.wifeDeathDate),
                AppTextFormField(labelText: "Mobile No.", controller: addRelationController.wifeNumber,keyboardType: TextInputType.number,),
                AppTextFormField(labelText: "Email", controller: addRelationController.wifeEmail),
                Container(
                  height: 64,
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                      border: Border.all(
                          color: AppColors.text,
                          width: 1
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8,top: 4),
                        child: Text("Select Gender",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                      ),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppRadioButton(items: ["Female"], selectedIndex: 0),
                      )),
                    ],
                  ),
                ),
                AppTextFormField(labelText: "Blood Group", controller: addRelationController.wifeBloodGroup),
                Text("Professional Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                AppDropDownField(profession: addRelationController.wifeProfession),
                AppTextFormField(labelText: "Describe Profession", controller: addRelationController.wifeSubProfession),
                AppTextFormField(labelText: "Business Email", controller: addRelationController.wifeBusinessEmail),
                AppTextFormField(labelText: "Business Contact", controller: addRelationController.wifeBusinessNumber,keyboardType: TextInputType.number,),
                AppTextFormField(labelText: "Business Address", controller: addRelationController.wifeBusinessAddress),
                SizedBox(height: 10,),
                ActiveButton(
                    height: 45,
                    onTap: (){
                      Get.back();
                    }, text: "Submit"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
