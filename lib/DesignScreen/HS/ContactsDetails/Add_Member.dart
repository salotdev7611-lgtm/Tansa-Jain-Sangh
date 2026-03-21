import 'dart:io';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Add_Contacts_Controller.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Select_Parent.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_field.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Widgets/DropDownFields/app_drop_down_surname.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {

  final AddContactsController addContactsController = Get.put(AddContactsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Member Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Form(
            key: addContactsController.memberDetails,
            child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Text("Home Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              // AppTextFormField(labelText: "Address", controller: addContactsController.address,
              // validator: (value){
              //   if(value!.isEmpty){
              //     return "Please Enter Address";
              //   }
              //   return null;
              // },
              // ),
              // AppTextFormField(labelText: "City", controller: addContactsController.city,
              //   validator: (value){
              //     if(value!.isEmpty){
              //       return "Please Enter City";
              //     }
              //     return null;
              //   },
              // ),
              // AppTextFormField(labelText: "State", controller: addContactsController.state,
              //   validator: (value){
              //     if(value!.isEmpty){
              //       return "Please Valid State";
              //     }
              //     return null;
              //   },
              // ),
              // AppTextFormField(labelText: "Country", controller: addContactsController.country,
              //   validator: (value){
              //     if(value!.isEmpty){
              //       return "Please Valid Address";
              //     }
              //     return null;
              //   },
              // ),
              // AppTextFormField(labelText: "Pin Code", controller: addContactsController.pinCode,keyboardType: TextInputType.number,maxLength: 6,
              //   validator: (value){
              //     if(value!.isEmpty){
              //       return "Please Valid Pin Code";
              //     }
              //     return null;
              //   },
              // ),

              // Text("Member Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              Obx(() =>  Center(
                child: InkWell(
                  onTap: (){
                    addContactsController.profileImagePicker();
                  },
                  child: Container(
                      height: 140,
                      width: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: addContactsController.profileImage.value.isNotEmpty ? AppColors.white:AppColors.text,
                        borderRadius: BorderRadius.circular(10),
                        image: addContactsController.profileImage.value.isNotEmpty
                            ? DecorationImage(
                          image: addContactsController.profileImage.value.startsWith("http")
                              ? NetworkImage(addContactsController.profileImage.value)
                              : FileImage(File(addContactsController.profileImage.value))
                          as ImageProvider,
                          fit: BoxFit.contain,
                        )
                            : null,
                      ),
                      child: addContactsController.profileImage.value.isEmpty
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
                          : SizedBox()
                  ),
                ),
              ),),
              Row(
                children: [
                  Expanded(child: AppTextFormField(labelText: "Name", controller: addContactsController.name,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please Valid Pin Code";
                      }
                      return null;
                    },
                  )),
                  SizedBox(width: 16,),
                  Expanded(child: AppDropDownSurname(surname: addContactsController.surname,readOnly: false,)),

                ],
              ),
              AppTextFormField(labelText: "Mobile No.", controller: addContactsController.mobile,keyboardType: TextInputType.number,maxLength: 10,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please Valid Mobile No.";
                  }
                  return null;
                },
              ),

              Text("Add Parents",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              Obx(() =>
              addContactsController.selectFatherName.value == true
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(SelectParent(surname: addContactsController.surname.dropDownValue?.value.toString() ?? "",),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: Container(
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
                              addContactsController.imageFather
                                  .startsWith('assets/')
                                  ? AssetImage(
                                addContactsController.imageFather.value,
                              )
                                  : FileImage(
                                File(addContactsController.imageFather.value),
                              ) as ImageProvider,
                            ),
                            Text(addContactsController.nameFather.value.toString()),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined,color: AppColors.text,size: 20,),

                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(SelectParent(surname: addContactsController.surname.dropDownValue?.value.toString() ?? "",),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: Container(
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
                              addContactsController.imageMother
                                  .startsWith('assets/')
                                  ? AssetImage(
                                addContactsController.imageMother.value,
                              )
                                  : FileImage(
                                File(addContactsController.imageMother.value),
                              ) as ImageProvider,
                            ),
                            Text(addContactsController.nameMother.value.toString()),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined,color: AppColors.text,size: 20,),
                          ],
                        ),
                      ),),
                  ),
                ],
              )
                  : InkWell(
                onTap: (){

                  if(addContactsController.surname.dropDownValue?.value == null || addContactsController.surname.dropDownValue!.value!.isEmpty){
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            width: Get.width,
                            content: Container(
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(padding: EdgeInsetsGeometry.all(8),
                                child: Text("Please Select Surname",style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                              ),
                            ))); }
                  else{
                    Get.to(SelectParent(surname: addContactsController.surname.dropDownValue?.value.toString() ?? "",),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                  }
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
              SizedBox(height: 40,),

              ActiveButton(
                  height: 45,
                  onTap: (){
                    if(addContactsController.memberDetails.currentState!.validate()){
                      addContactsController.addMember();
                    }

                  },
                  text: "ADD MEMBER"
              ),
              // SizedBox(height: 20,),
            ],
          ),)
        ),
      ),
    );
  }
}
