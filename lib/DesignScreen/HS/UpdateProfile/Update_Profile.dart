import 'dart:io';

import 'package:family_app/DesignScreen/HS/UpdateProfile/UpdateProfileController.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_field.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_reltion.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../Widgets/DropDownFields/app_drop_down_surname.dart';
import '../../../Widgets/RadioButtons/app_radio_button_controller.dart';
import '../../../Widgets/RadioButtons/app_radio_button_marital.dart';
import '../Add Member/Married_Form.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key, required this.memberId});
  final String memberId;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text(
          "Update Profile",
          style: Theme.of(context)
              .textTheme
              .bodyBold
              .copyWith(color: AppColors.text),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Center(
                  child: Obx(() => InkWell(
                      onTap: (){
                        updateProfileController.profileImagePicker();
                      },
                      child:Container(
                        height: 140,
                        width: 130,
                        decoration: BoxDecoration(
                          color:updateProfileController.profile.value.isNotEmpty? AppColors.white: AppColors.text,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: updateProfileController.profile.value.isNotEmpty
                              ? DecorationImage(
                            image: updateProfileController.profile.value.startsWith("http")
                                ? NetworkImage(updateProfileController.profile.value)
                                : FileImage(File(updateProfileController.profile.value))
                            as ImageProvider,
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: updateProfileController.profile.value.isEmpty
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.string(
                              AppSvgs.user,
                              color: AppColors.white,
                              height: 40,
                              width: 40,
                            ),
                            Text(
                              "Upload Profile",
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
              Row(
                spacing: 12,
                children: [
                  Expanded(child: AppTextFormField(labelText: "First Name", controller: updateProfileController.name)),
                  Expanded(child: AppDropDownSurname(surname: updateProfileController.lastName,readOnly: true,)),
                ],
              ),
              AppTextFormField(labelText: "Date Of Birth", controller: updateProfileController.dateOfBirth),
              AppTextFormField(labelText: "Mobile Number", controller: updateProfileController.number,keyboardType: TextInputType.number,maxLength: 10,),
              AppTextFormField(labelText: "email", controller: updateProfileController.email),
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Gender",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppRadioButton(items: ["Male" ,"Female"], selectedIndex:  appRadioButtonController.selectedIndexGender.value),
                      )),
                    ],
                  ),
                ),
              ),
              AppTextFormField(labelText: "Blood Group", controller: updateProfileController.bloodGroup),
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
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppRadioButtonMarital(
                            items: ["Unmarried", "Married"],
                            selectedIndex: appRadioButtonController.selectedIndexMarital.value,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Obx(() => Visibility(
              //     visible: appRadioButtonController.selectedIndexMarital == 1,
              //     child: InkWell(
              //       onTap: (){
              //         FocusScope.of(context).nextFocus();
              //         Get.to(
              //           MarriedForm(),
              //           transition: Transition.fadeIn,
              //           duration: const Duration(milliseconds: 100),
              //         );
              //       },
              //       child: Container(
              //         width: Get.width,
              //         // height: 100,
              //         decoration: BoxDecoration(
              //             color: AppColors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: AppColors.text, width: 1),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Color(0xff14453D33).withValues(alpha: 0.2),
              //                 spreadRadius: 0,
              //                 blurRadius: 10,
              //                 offset: Offset(0, 0),
              //               ),
              //             ]
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             spacing: 18,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Text(updateProfileController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Married To" :"Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
              //                   addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? SvgPicture.string(AppSvgs.edit1) : SizedBox(),
              //                   // Text(addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Edit" :"",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
              //                 ],
              //               ),
              //               addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1
              //                   ? Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 spacing: 18,
              //                 children: [
              //                   Row(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     spacing: 12,
              //                     children: [
              //                       SizedBox(
              //                         height: 80,
              //                         width: 80,
              //                         child: ClipRRect(
              //                           borderRadius: BorderRadius.circular(8),
              //                           child: Image.file(
              //                             File(addMemberController.marriedImage.value),
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       ),
              //                       Column(
              //                         spacing: 12,
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Text("${addMemberController.marriedName.value} ${addMemberController.marriedLastName}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
              //                           Text(addMemberController.marriedNumber.value,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
              //                         ],
              //                       )
              //                     ],
              //                   )
              //                 ],
              //               )
              //                   : Center(
              //                 child: Text("+ Add Your Partner",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.buttonColor),),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     )),),
              Text("Professional Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              AppDropDownField(profession: updateProfileController.profession),
              AppTextFormField(labelText: "Describe Professional", controller: updateProfileController.subProfession),
              AppTextFormField(labelText: "Business email", controller: updateProfileController.businessEmail),
              AppTextFormField(labelText: "Business Connect", controller: updateProfileController.businessNumber,keyboardType: TextInputType.number,maxLength: 10,),
              AppTextFormField(labelText: "Business Address", controller: updateProfileController.businessAddress,),

              ActiveButton(
                  height: 45,
                  onTap: (){
                    // loginScreenController.addVidhi.value = true;
                    // addMemberController.married.value = false;
                    // appRadioButtonController.selectedIndexMarital.value = 0;
                    FocusScope.of(context).unfocus();
                    updateProfileController.updateProfile(widget.memberId);

                  }, text: "Update Member")
            ],
          ),
        ),
      ),
    );
  }
}
