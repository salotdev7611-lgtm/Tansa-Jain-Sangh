import 'dart:io';

import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';
import '../HomeScreen/Admin_Bottom_Nav_Bar.dart';

class FamilyMember extends StatefulWidget {
  const FamilyMember({super.key, required this.name, required this.lastName, required this.mobileNo, required this.image, required this.status, required this.wifeName, required this.wifeLastName, required this.wifeImage, required this.wifeNumber});
  final String name;
  final String lastName;
  final String mobileNo;
  final String status;
  final String image;
  final String wifeName;
  final String wifeLastName;
  final String wifeNumber;
  final String wifeImage;

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AddMemberController addMemberController = Get.put(AddMemberController());
  final SelectFatherController selectFatherController = Get.put(SelectFatherController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Family Member",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          spacing: 16,
          children: [
            Container(
              // height: 300,
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff14453D33).withValues(alpha: 0.8),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: widget.image.isEmpty
                                      ? Container(
                                    color: Colors.grey.shade300,
                                    child: Image.asset("assets/images/no-image.png")
                                  )
                                      : widget.image.startsWith("http")
                                      ? Image.network(
                                    widget.image,
                                    fit: BoxFit.contain,
                                  )
                                      : Image.file(
                                    File(widget.image),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              Text("Name : ${widget.name} ${widget.lastName}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                              Text("Connect No. : ${widget.mobileNo}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                              Text("Status : ${widget.status}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.wifeImage.isNotEmpty
                                  ?     SizedBox(
                          height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.wifeImage.isEmpty
                                  ? Container(
                                  color: Colors.grey.shade300,
                                  child: Image.asset("assets/images/no-image.png")
                              )
                                  : widget.wifeImage.startsWith("http")
                                  ? Image.network(
                                widget.wifeImage,
                                fit: BoxFit.contain,
                              )
                                  : Image.file(
                                File(widget.wifeImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                                  :SizedBox(),

                              widget.wifeName.isNotEmpty && widget.wifeLastName.isNotEmpty
                                  ? Text("Name : ${widget.wifeName} ${widget.wifeLastName}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text))
                                  : SizedBox(),

                              widget.wifeNumber.isNotEmpty
                                  ? Text("Connect No. : ${widget.wifeNumber}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text))
                                  :SizedBox(),
                              widget.status == "Married"?
                              Text("Status : ${widget.status}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text))
                                  :SizedBox()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                addMemberController.addApiCall.value = true;
                addMemberController.profileImage.value = "";
                addMemberController.number.clear();
                addMemberController.name.clear();
                addMemberController.lastName.value.dropDownValue = null;
                addMemberController.number.clear();
                addMemberController.dateOfBirth.clear();
                addMemberController.deathDate.clear();
                addMemberController.email.clear();
                addMemberController.bloodGroup.clear();
                addMemberController.subProfession.clear();
                addMemberController.businessEmail.clear();
                addMemberController.businessNumber.clear();
                addMemberController.businessAddress.clear();
                selectFatherController.nameFather.value = "";
                selectFatherController.nameMother.value = "";
                selectFatherController.selectedMotherNames.clear();
                selectFatherController.selectedFatherNames.clear();
                appRadioButtonController.selectedIndexMarital.value = 0;
                Get.back();
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: appColors.selectedColor.value,
                        width: 1
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(AppSvgs.add,color: appColors.selectedColor.value,),
                    Text("Add Another Member",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
        child: InkWell(
          onTap: ()async{
            await loginScreenController.checkLoginStatus();
            // Get.offAll(AdminBottomNavBar(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
            // Get.to(AddMember(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          },
          child: Container(
            height: 45,
            width: 200,
            decoration: BoxDecoration(
              color: appColors.selectedColor.value,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text("Submit",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),)),
          ),
        ),
      ),
    );
  }
}
