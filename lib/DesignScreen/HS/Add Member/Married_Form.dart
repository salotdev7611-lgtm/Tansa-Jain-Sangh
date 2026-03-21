import 'dart:io';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Married_Form_Controller.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/Buttons/active_button.dart';
import '../../../Widgets/DropDownFields/app_drop_down_field.dart';
import '../../../Widgets/DropDownFields/app_drop_down_reltion.dart';
import '../../../Widgets/RadioButtons/app_radio_button.dart';
import '../../../Widgets/TextFormFields/app_text_form_field.dart';

class MarriedForm extends StatefulWidget {
  const MarriedForm({super.key});

  @override
  State<MarriedForm> createState() => _MarriedFormState();
}

class _MarriedFormState extends State<MarriedForm> {

  final AddMemberController addMemberController = Get.put(AddMemberController());
  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Married Form",style: Theme.of(context).textTheme.bodyBold,),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Form(
                key: addMemberController.addWifeKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Center(
                        child: Obx(() => InkWell(
                            onTap: (){
                              addMemberController.wifeProfileImagePicker();
                            },
                            child:Container(
                              height: 140,
                              width: 130,
                              decoration: BoxDecoration(
                                color: AppColors.text,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),

                                image: addMemberController.wifeProfileImage.value.isNotEmpty
                                    ? DecorationImage(
                                  image: addMemberController.wifeProfileImage.value.startsWith("http")
                                      ? NetworkImage(addMemberController.wifeProfileImage.value)
                                      : FileImage(File(addMemberController.wifeProfileImage.value))
                                  as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: addMemberController.wifeProfileImage.value.isEmpty
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
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(child: AppTextFormField(labelText: "First Name", controller: addMemberController.wifeName,

                            validator: (value){
                              if(value!.isEmpty){
                                return "Please Enter First Name";
                              }
                              return null;
                            }
                        )),
                        Expanded(child: AppDropDownSurname(surname: addMemberController.wifeSurname,readOnly: true,)),
                      ],
                    ),
                    // AppTextFormField(labelText: "Date Of Birth", controller: addMemberController.wifeDateOfBirth,
                    //     validator: (value){
                    //       if(value!.isEmpty){
                    //         return "Please Enter Date Of Birth";
                    //       }
                    //       return null;
                    //     }
                    // ),
                    AppTextFormField(labelText: "Date Of Birth", controller: addMemberController.wifeDateOfBirth,  validator: (value){
                      if(value == null || value.isEmpty){
                        return "Required This Date";
                      }
                      final RegExp dateRegex =
                      RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                      if (!dateRegex.hasMatch(value.trim())) {
                        return "valid format (DD-MM-YYYY)";
                      }
                      return null;
                    },
                      datePickerOnTap: () async{
                        final date = await showDatePickerDialog(
                          context: context,
                          maxDate: DateTime(
                            DateTime.now().year + 10, 12, 31,),
                          minDate:  DateTime(1800, 01, 01),
                          width: Get.width,
                          height: 400,
                          currentDateDecoration: BoxDecoration(
                            color: appColors.selectedColor.value,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          currentDateTextStyle: TextStyle(
                              color: AppColors.white
                          ),
                          daysOfTheWeekTextStyle: const TextStyle(),
                          disabledCellsTextStyle: const TextStyle(),
                          enabledCellsDecoration:  BoxDecoration(),
                          enabledCellsTextStyle: const TextStyle(),
                          initialPickerType: PickerType.days,
                          selectedCellDecoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColors.selectedColor.value,
                          ),
                          selectedCellTextStyle: const TextStyle(),
                          leadingDateTextStyle: const TextStyle(),
                          slidersColor: Colors.lightBlue,
                          highlightColor: Colors.redAccent,
                          slidersSize: 20,
                          splashColor: Colors.lightBlueAccent,
                          splashRadius: 40,
                          centerLeadingDate: true,
                        );
                        print("selected date ${DateFormat("dd-MM-yyyy").format(DateTime.parse("${date}"))}");
                        addMemberController.wifeDateOfBirth.text = DateFormat("dd-MM-yyyy").format(DateTime.parse("${date}"));
                      },
                    ),
                    AppTextFormField(labelText: "Death Date", controller: addMemberController.wifeDeathDate,),
                    AppTextFormField(labelText: "Mobile Number", controller: addMemberController.wifeNumber,keyboardType: TextInputType.number,maxLength: 10,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Number";
                          }
                          return null;
                        }
                    ),
                    AppTextFormField(labelText: "email", controller: addMemberController.wifeEmail,
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Please Enter Email";
                        //   }
                        //   return null;
                        // }
                    ),
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
                              child: AppRadioButton(items: ["Female"], selectedIndex:  0),
                            )),
                          ],
                        ),
                      ),
                    ),
                    AppTextFormField(labelText: "Blood Group", controller: addMemberController.wifeBloodGroup,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please Enter Blood Group";
                          }
                          return null;
                        }
                    ),
                    Text("Professional Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                    AppDropDownField(profession: addMemberController.wifeProfession,),
                    AppTextFormField(labelText: "Describe Professional", controller: addMemberController.wifeSubProfession,
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Please Enter Describe Professional";
                        //   }
                        //   return null;
                        // }
                    ),
                    AppTextFormField(labelText: "Business email", controller: addMemberController.wifeBusinessEmail,
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Please Enter Business Email";
                        //   }
                        //   return null;
                        // }
                    ),
                    AppTextFormField(labelText: "Business Connect", controller: addMemberController.wifeBusinessNumber,keyboardType: TextInputType.number,maxLength: 10,
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Please Enter Business Connect";
                        //   }
                        //   return null;
                        // }
                    ),
                    AppTextFormField(labelText: "Business Address", controller: addMemberController.wifeBusinessAddress,
                        // validator: (value){
                        //   if(value!.isEmpty){
                        //     return "Please Enter Business Address";
                        //   }
                        //   return null;
                        // }
                    ),

                    ActiveButton(
                        height: 45,
                        onTap: (){
                          print("addMemberController.addApiCall.value  ${addMemberController.addApiCall.value}");
                          if (addMemberController.addApiCall.value == true && addMemberController.addWifeKey.currentState!.validate()) {
                            print("addMemberController.addApiCall.value true  ${addMemberController.addApiCall.value}");
                            addMemberController.married.value = true;
                            addMemberController.marriedName.value =
                                addMemberController.wifeName.text;
                            addMemberController.marriedLastName.value =
                                addMemberController.wifeSurname.dropDownValue?.name ?? "";
                            addMemberController.marriedImage.value =
                                addMemberController.marriedImage.value;
                            addMemberController.marriedNumber.value =
                                addMemberController.wifeNumber.text;

                            Get.back();
                          }
                          else if(addMemberController.addApiCall.value == false && addMemberController.addWifeKey.currentState!.validate()) {
                            addMemberController.married.value = true;
                            addMemberController.marriedName.value =
                                addMemberController.wifeName.text;
                            addMemberController.marriedLastName.value =
                                addMemberController.wifeSurname.dropDownValue?.name ?? "";
                            addMemberController.marriedImage.value =
                                addMemberController.marriedImage.value;
                            addMemberController.marriedNumber.value =
                                addMemberController.wifeNumber.text;
                            print("wife add");
                            print("addMemberController.addApiCall.value false addWife ${addMemberController.addApiCall.value}");
                            addMemberController.addWife();
                            Get.back();
                          }

                          // if(addMemberController.addWifeKey.currentState!.validate()){
                          //   addMemberController.married.value = true;
                          //   addMemberController.marriedName.value = addMemberController.wifeName.text;
                          //   addMemberController.marriedLastName.value = addMemberController.wifeSurname.dropDownValue?.name ?? "";
                          //   addMemberController.marriedImage.value = addMemberController.marriedImage.value;
                          //   addMemberController.marriedNumber.value = addMemberController.wifeNumber.text;
                          //   Get.back();
                          //   // Get.to(AddMember(name: marriedFormController.name.text.toString(), image: marriedFormController.profileImage.value.toString(), lastName: marriedFormController.surname.dropDownValue.toString(),));
                          // }
                        },
                        text: "Submit"
                    )
                  ],
                ))
        ),
      ),
    );
  }
}
