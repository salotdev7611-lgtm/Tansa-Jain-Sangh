import 'dart:io';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Married_Form.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Married_Form_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeAdd/Home_Add_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_field.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_marital.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Helpers/app_svgs.dart';

class AddMemberUser extends StatefulWidget {
  const AddMemberUser({super.key,});

  @override
  State<AddMemberUser> createState() => _AddMemberUserState();
}

class _AddMemberUserState extends State<AddMemberUser> {

  final AddMemberController addMemberController = Get.put(AddMemberController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final SelectFatherController selectFatherController = Get.put(SelectFatherController());
  final AppColors appColors = Get.put(AppColors());
  final HomeAddController homeAddController = Get.put(HomeAddController());
  final AdminSettingController adminSettingController = Get.put(AdminSettingController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      homeAddController.checkMember();
      adminSettingController.getProfession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Add Member",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Form(
              key: addMemberController.addMemberKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Center(
                      child: Obx(() => InkWell(
                          onTap: (){
                            addMemberController.profileImagePicker();
                          },
                          child:Container(
                            height: 140,
                            width: 130,
                            decoration: BoxDecoration(
                              color: addMemberController.profileImage.value.isNotEmpty?Colors.transparent:AppColors.text,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              image: addMemberController.profileImage.value.isNotEmpty
                                  ? DecorationImage(
                                image: addMemberController.profileImage.value.startsWith("http")
                                    ? NetworkImage(addMemberController.profileImage.value)
                                    : FileImage(File(addMemberController.profileImage.value))
                                as ImageProvider,
                                fit: BoxFit.contain,
                              )
                                  : null,
                            ),
                            child: addMemberController.profileImage.value.isEmpty
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
                      Expanded(
                          child: AppTextFormField(
                            labelText: "Name",
                            controller: addMemberController.name,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Required This Name";
                              }
                              return null;
                            },)),
                      Expanded(child: Obx(() =>  AppDropDownSurname(surname: addMemberController.lastName.value,readOnly: true,))),
                    ],
                  ),
                  Obx(() =>
                  selectFatherController.nameFather.value.isNotEmpty
                      ? GestureDetector(
                    onTap: (){
                      selectFatherController.fetchParent(memberId: selectFatherController.fatherID.value);
                      print(" addMemberController.memberId.value : ${ selectFatherController.fatherID.value}");
                      selectFatherController.sonId.value =  selectFatherController.fatherID.value;
                      Get.to(SelectFather(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: Column(
                      spacing: 12,
                      children: [
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: AppColors.text,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 12,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  selectFatherController.imageFather.startsWith("http")
                                      ? NetworkImage(selectFatherController.imageFather.value,)
                                      : FileImage(File(selectFatherController.imageFather.value),
                                  ) as ImageProvider,
                                  radius: 20,
                                ),
                                Text(selectFatherController.nameFather.value.toString()),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: AppColors.text,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              spacing: 12,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  selectFatherController.imageMother.startsWith("http")
                                      ? NetworkImage(selectFatherController.imageMother.value,)
                                      : FileImage(File(selectFatherController.imageMother.value),
                                  ) as ImageProvider,
                                  radius: 20,
                                  backgroundColor: AppColors.white,
                                ),
                                Text(selectFatherController.nameMother.value.toString()),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : InkWell(
                    onTap: (){
                      if(selectFatherController.selectedFatherNames.isEmpty){
                        selectFatherController.sonId.value = addMemberController.memberId.value;
                        print("SON ID ${selectFatherController.sonId.value}");
                      }
                      Get.to(SelectFather(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: AppColors.text,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Select Father",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                            Icon(Icons.arrow_forward_ios_outlined,color: AppColors.text,size: 20,),
                          ],
                        ),
                      ),
                    ),
                  ),),

                  AppTextFormField(labelText: "Date Of Birth", controller: addMemberController.dateOfBirth,  validator: (value){
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
                      addMemberController.dateOfBirth.text = DateFormat("dd-MM-yyyy").format(DateTime.parse("${date}"));
                    },
                  ),

                  Obx(() => addMemberController.death.value == true || addMemberController.deathDate.text.isNotEmpty
                      ? AppTextFormField(labelText: "Death Date", controller: addMemberController.deathDate,  validator: (value){
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
                      addMemberController.deathDate.text = DateFormat("dd-MM-yyyy").format(DateTime.parse("${date}"));
                    },
                  )
                      : Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                      border: Border.all(
                        width: 1,
                        color: AppColors.text,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 6,),
                        Text("Is Stile Leaving",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                        Spacer(),
                        GestureDetector(
                            onTap: (){
                              addMemberController.death.value = true;
                              addMemberController.leaving.value = false;
                            },
                            child: Text("Yes",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.primaryGreen),)),
                        SizedBox(width: 16,),
                      ],
                    ),
                  ),),

                  AppTextFormField(labelText: "Mobile Number", controller: addMemberController.number,keyboardType: TextInputType.number,maxLength: 10,  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Required This number";
                    }
                    return null;
                  },),
                  AppTextFormField(labelText: "email", controller: addMemberController.email,  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Required This email";
                    }
                    return null;
                  },),
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
                            child: AppRadioButton(items: ["Male" ,"Female"], selectedIndex:  0),
                          )),
                        ],
                      ),
                    ),
                  ),
                  AppTextFormField(labelText: "Blood Group", controller: addMemberController.bloodGroup,
                    // validator: (value){
                    //   if(value == null || value.isEmpty){
                    //     return "Required Blood Group";
                    //   }
                    //   return null;
                    // },
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
                          Text("Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() => Visibility(
                      visible: appRadioButtonController.selectedIndexMarital == 1,
                      child: InkWell(
                        onTap: (){
                          FocusScope.of(context).nextFocus();
                          Get.to(
                            MarriedForm(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 100),
                          );
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
                                    Text(addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Married To" :"Select Marital Status",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                                    addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? SvgPicture.string(AppSvgs.edit1) : SizedBox(),
                                    // Text(addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1? "Edit" :"",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                                  ],
                                ),
                                addMemberController.married.value && appRadioButtonController.selectedIndexMarital == 1
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
                                              File(addMemberController.wifeProfileImage.value),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          spacing: 12,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${addMemberController.marriedName.value} ${addMemberController.marriedLastName}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                                            Text(addMemberController.marriedNumber.value,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
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

                  Text("Professional Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  AppDropDownField(profession: addMemberController.profession,),
                  AppTextFormField(labelText: "Describe Professional", controller: addMemberController.subProfession,
                    // validator: (value){
                    //   if(value == null || value.isEmpty){
                    //     return "Required Describe Professional";
                    //   }
                    //   return null;
                    // },
                  ),
                  AppTextFormField(labelText: "Business email", controller: addMemberController.businessEmail,
                    // validator: (value){
                    //   if(value == null || value.isEmpty){
                    //     return "Required Business email";
                    //   }
                    //   return null;
                    // },
                  ),
                  AppTextFormField(labelText: "Business Connect", controller: addMemberController.businessNumber,keyboardType: TextInputType.number,maxLength: 10,
                    // validator: (value){
                    //   if(value == null || value.isEmpty){
                    //     return "Required Business Connect";
                    //   }
                    //   return null;
                    // },

                  ),
                  AppTextFormField(labelText: "Business Address", controller: addMemberController.businessAddress,
                    // validator: (value){
                    //   if(value == null || value.isEmpty){
                    //     return "Required Business Address";
                    //   }
                    //   return null;
                    // },
                  ),
                  ActiveButton(
                      height: 45,
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        final isAdd = addMemberController.addApiCall.value;
                        print("isAddMode: $isAdd");

                        if (isAdd) {
                          if (!addMemberController.addMemberKey.currentState!.validate()) {
                            return;
                          }
                          addMemberController.addMember();

                          addMemberController.married.value = false;
                          appRadioButtonController.selectedIndexMarital.value = 0;
                        } else {
                          addMemberController.editMember();
                          homeAddController.surname.dropDownValue =  DropDownValueModel(
                            name: homeAddController.checkData.first["surname"],
                            value: homeAddController.checkData.first["surname"],
                          );
                        }
                      },
                      text: "Member")
                ],
              )
          ),
        ),
      ),
    );
  }
}
