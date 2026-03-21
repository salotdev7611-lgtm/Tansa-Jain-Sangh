import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/Parent.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/Wife_Relation.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/Buttons/active_button.dart';
import '../../../Widgets/DropDownFields/app_drop_down_field.dart';
import '../../../Widgets/DropDownFields/app_drop_down_reltion.dart';
import '../../../Widgets/DropDownFields/app_drop_down_surname.dart';
import '../../../Widgets/RadioButtons/app_radio_button.dart';
import '../../../Widgets/RadioButtons/app_radio_button_marital.dart';
import '../../../Widgets/TextFormFields/app_text_form_field.dart';
import 'Add_Relation_Controller.dart';

class AddRelation extends StatefulWidget {
  const AddRelation({super.key});

  @override
  State<AddRelation> createState() => _AddRelationState();
}

class _AddRelationState extends State<AddRelation> {

  final AddRelationController addRelationController = Get.put(AddRelationController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Add Relation",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: addRelationController.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Obx(() => InkWell(
                        onTap: (){
                          addRelationController.profileImagePicker();
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
                    Expanded(child: AppTextFormField(labelText: "First Name", controller: addRelationController.firstName,)),
                    Expanded(child: AppDropDownSurname(surname: addRelationController.lastName,readOnly: true,)),
                  ],
                ),
                Obx(() => addRelationController.nameFather.isEmpty && addRelationController.nameMother.isEmpty
                    ? GestureDetector(
                  onTap: (){
                    Get.to(Parent(),transition: Transition.fadeIn,duration: Duration(milliseconds: 500));
                  },
                  child: Container(
                    height: 45,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                      border: Border.all(
                          color: AppColors.text,
                          width: 1
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Parent",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                          Icon(Icons.arrow_forward_ios_outlined,color: AppColors.text,size: 15,)
                        ],
                      ),
                    ),
                  ),
                )
                    : Column(
                  spacing: 12,
                      children: [
                        GestureDetector(
                          onTap : (){
                            Get.to(Parent(),transition: Transition.fadeIn,duration: Duration(milliseconds: 500));
                          },
                          child: Container(
                            height: 45,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.text,
                                  width: 1
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(image:
                                      addRelationController.imageFather.value.isNotEmpty
                                       ? NetworkImage(addRelationController.imageFather.value)
                                      : AssetImage("assets/images/no-image.png"),
                                        fit: BoxFit.contain
                                      ),
                                    ),
                                    height: 35,
                                    width: 35,
                                  ),
                                ),
                                Text(addRelationController.nameFather.value,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white,
                            border: Border.all(
                                color: AppColors.text,
                                width: 1
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image:
                                    addRelationController.imageMother.value.isNotEmpty
                                   ? NetworkImage(addRelationController.imageMother.value)
                                    : AssetImage("assets/images/no-image.png"),
                                      fit: BoxFit.contain
                                    ),

                                  ),
                                  height: 35,
                                  width: 35,
                                ),
                              ),
                              Text(addRelationController.nameMother.value,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                            ],
                          ),
                        ),
                      ],
                    ),),

                AppTextFormField(labelText: "Date Of Birth", controller: addRelationController.dateOfBirth),
                AppTextFormField(labelText: "Death Date.", controller: addRelationController.deathDate),
                AppTextFormField(labelText: "Mobile No.", controller: addRelationController.mobileNo,keyboardType: TextInputType.number,),
                AppTextFormField(labelText: "Email.", controller: addRelationController.email),
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
                        child: AppRadioButton(items: ["Male" ,"Female"], selectedIndex: 0),
                      )),
                    ],
                  ),
                ),
                AppTextFormField(labelText: "Blood Group", controller: addRelationController.bloodGroup),
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
                        child: Text("Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppRadioButtonMarital(
                              items: ["Unmarried", "Married"],
                              selectedIndex: 0,
                              onChanged: (index, value) {
                                if (value == "Married") {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    // Get.to(
                                    //   MarriedForm(),
                                    //   transition: Transition.fadeIn,
                                    //   duration: const Duration(milliseconds: 100),
                                    // );
                                  });
                                }
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                Obx(() => Visibility(
                    visible: appRadioButtonController.selectedIndexMarital == 1,
                    child: InkWell(
                      onTap: (){
                        FocusScope.of(context).nextFocus();
                        Get.to(
                          WifeRelation(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        width: Get.width,
                        // height: 100,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.text, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff14453D33).withValues(alpha: 0.2),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 18,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(addRelationController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Married To" :"Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                                  addRelationController.married.value && appRadioButtonController.selectedIndexMarital == 1? SvgPicture.string(AppSvgs.edit1) : SizedBox(),
                                  // Text(addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Edit" :"",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                                ],
                              ),
                              addRelationController.married.value && appRadioButtonController.selectedIndexMarital == 1
                                  ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 18,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 12,
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(addRelationController.wifeProfileImage.value),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        spacing: 12,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${addRelationController.marriedName.value} ${addRelationController.marriedLastName}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                                          Text(addRelationController.marriedNumber.value,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              )
                                  : Center(
                                  child: Obx(() => Text(
                                    "+ Add Your Partner",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyBold
                                        .copyWith(color: appColors.selectedColor.value),
                                  ))
                              )
                            ],
                          ),
                        ),
                      ),
                    )),),
                ///select profession
                Text("Professional Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                AppDropDownField(profession: addRelationController.profession,),
                AppTextFormField(labelText: "Describe Profession", controller: addRelationController.describeProfession),
                AppTextFormField(labelText: "Business Email", controller: addRelationController.businessEmail),
                AppTextFormField(labelText: "Business Contact", controller: addRelationController.businessContact,keyboardType: TextInputType.number,),
                AppTextFormField(labelText: "Business Address", controller: addRelationController.businessAddress),
                ActiveButton(
                    height: 45,
                    onTap: (){
                      addRelationController.addRelation();
                    }, text: "Submit"),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
