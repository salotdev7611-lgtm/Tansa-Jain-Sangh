import 'dart:io';

import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member.dart';
import 'package:family_app/DesignScreen/HS/HomeAdd/Home_Add_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_reltion.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAdd extends StatefulWidget {
  const HomeAdd({super.key});

  @override
  State<HomeAdd> createState() => _HomeAddState();
}

class _HomeAddState extends State<HomeAdd> {

  final HomeAddController homeAddController = Get.put(HomeAddController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: Text("Add Address",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Obx(() => InkWell(
                      onTap: (){
                        homeAddController.profileImagePicker();
                      },
                      child:Container(
                        height: 140,
                        width: 130,
                        decoration: BoxDecoration(
                          color: homeAddController.profileImage.value.isNotEmpty?Colors.transparent:AppColors.text,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          image: homeAddController.profileImage.value.isNotEmpty
                              ? DecorationImage(
                            image: homeAddController.profileImage.value.startsWith("http")
                                ? NetworkImage(homeAddController.profileImage.value)
                                : FileImage(File(homeAddController.profileImage.value))
                            as ImageProvider,
                            fit: BoxFit.contain,
                          )
                              : null,
                        ),
                        child: homeAddController.profileImage.value.isEmpty
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
              Text("Relation",style:  Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.white,
                    border: Border.all(
                        color: AppColors.text,
                        width: 1
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppRadioButton(
                    items: ["Son", "Daughter", "Brother", "Sister"],
                    selectedIndex: appRadioButtonController.selectedRelation.value,
                  ),
                ),
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                      child: AppTextFormField(
                        labelText: "Name",
                        controller: homeAddController.name,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Required This Name";
                          }
                          return null;
                        },)),
                  Expanded(child: AppDropDownSurname(surname: homeAddController.surname,readOnly: true,)),
                ],
              ),
              AppTextFormField(labelText: "Mobile No.", controller: homeAddController.mobileNo),
              AppTextFormField(labelText: "Address", controller: homeAddController.address),
              AppTextFormField(labelText: "City", controller: homeAddController.city),
              AppTextFormField(labelText: "State", controller: homeAddController.state),
              AppTextFormField(labelText: "Country", controller: homeAddController.county),
              AppTextFormField(labelText: "Pin Code", controller : homeAddController.pinCode),
              ActiveButton(
                height: 45,
                onTap: () {
                  homeAddController.homeAdd();
                }, text: 'Submit',),
            ],
          ),
        ),
      ),
      // body: Obx(() {
      //   if(homeAddController.get.value){
      //     return Center(child: CircularProgressIndicator());
      //   }
      //   else if(homeAddController.checkData.isEmpty){
      //     return Center(child: Text("No Address Found",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.red),));
      //   }
      //   else{
      //     return  Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      //       child: Column(
      //         spacing: 18,
      //         children: [
      //           Container(
      //             decoration: BoxDecoration(
      //                 color: AppColors.white,
      //                 borderRadius: BorderRadius.circular(10),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Color(0xff14453D33).withValues(alpha: 0.2),
      //                     spreadRadius: 0,
      //                     blurRadius: 10,
      //                     offset: Offset(0, 0),
      //                   ),
      //                 ]
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 12, vertical: 12),
      //               child: Column(
      //                 spacing: 8,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text("Home Address", style: Theme
      //                           .of(context)
      //                           .textTheme
      //                           .bodyBold
      //                           .copyWith(color: AppColors.text),),
      //                       GestureDetector(
      //                           onTap: () {
      //                             homeAddController.address.text =
      //                                 homeAddController.userAddress.value;
      //                             Get.bottomSheet(
      //                               isScrollControlled: true,
      //                               Container(
      //                                 height: 200,
      //                                 decoration: BoxDecoration(
      //                                   color: AppColors.white,
      //                                   borderRadius: BorderRadius.only(
      //                                     topRight: Radius.circular(10),
      //                                     topLeft: Radius.circular(10),
      //                                   ),
      //                                 ),
      //                                 child: Form(
      //                                     key: homeAddController.homeOne,
      //                                     child: Padding(
      //                                       padding: const EdgeInsets
      //                                           .symmetric(
      //                                           horizontal: 16, vertical: 12),
      //                                       child: Column(
      //                                         spacing: 12,
      //                                         crossAxisAlignment: CrossAxisAlignment
      //                                             .start,
      //                                         children: [
      //                                           Row(
      //                                             children: [
      //                                               Spacer(),
      //                                               Text("Home Address",
      //                                                   style: Theme
      //                                                       .of(context)
      //                                                       .textTheme
      //                                                       .bodyBold
      //                                                       .copyWith(
      //                                                     color: AppColors
      //                                                         .text,)),
      //                                               Spacer(),
      //                                               GestureDetector(
      //                                                   onTap: () {
      //                                                     Get.back();
      //                                                   },
      //                                                   child: SvgPicture
      //                                                       .string(
      //                                                     AppSvgs.closeCircle,
      //                                                     color: AppColors
      //                                                         .red,)),
      //                                             ],
      //                                           ),
      //                                           // AppTextFormField(labelText: "Name", controller: homeAddController.name,
      //                                           //   validator: (value){
      //                                           //     if(value == null || value.isEmpty){
      //                                           //       return "Please Enter the Name";
      //                                           //     }
      //                                           //     return null;
      //                                           //   },
      //                                           // ),
      //                                           AppTextFormField(
      //                                               labelText: "Address",
      //                                               controller: homeAddController
      //                                                   .address,
      //                                               validator: (value) {
      //                                                 if (value == null ||
      //                                                     value.isEmpty) {
      //                                                   return "Please Enter the Address";
      //                                                 }
      //                                                 return null;
      //                                               }
      //                                           ),
      //                                           ActiveButton(
      //                                               height: 45,
      //                                               onTap: () {
      //                                                 if (homeAddController
      //                                                     .homeOne
      //                                                     .currentState!
      //                                                     .validate()) {
      //                                                   // homeAddController.addAddress();
      //                                                   Get.back();
      //                                                 }
      //                                               }, text: "Update"),
      //                                         ],
      //                                       ),
      //                                     )),
      //                               ),
      //                             );
      //                           },
      //                           child: SvgPicture.string(AppSvgs.edit1)),
      //                     ],
      //                   ),
      //                   Text("Name", style: Theme
      //                       .of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),),
      //                   Container(
      //                     width: Get.width,
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(5),
      //                         color: AppColors.lightGrey,
      //                         border: Border.all(
      //                           color: AppColors.text,
      //                           width: 1,
      //                         )
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Text("${homeAddController
      //                           .checkData[0]["name"]} ${homeAddController
      //                           .checkData[0]["surname"]}", style: Theme
      //                           .of(context)
      //                           .textTheme
      //                           .body1Regular
      //                           .copyWith(color: AppColors.text),),
      //                     ),
      //                   ),
      //                   Text("Mobile No", style: Theme
      //                       .of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),),
      //                   Container(
      //                     width: Get.width,
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(5),
      //                         color: AppColors.lightGrey,
      //                         border: Border.all(
      //                           color: AppColors.text,
      //                           width: 1,
      //                         )
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Text(
      //                         homeAddController.checkData[0]["mobile_no"],
      //                         style: Theme
      //                             .of(context)
      //                             .textTheme
      //                             .body1Regular
      //                             .copyWith(color: AppColors.text),),
      //                     ),
      //                   ),
      //                   Text("Address", style: Theme
      //                       .of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),),
      //                   Container(
      //                     width: Get.width,
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(5),
      //                         color: AppColors.lightGrey,
      //                         border: Border.all(
      //                           color: AppColors.text,
      //                           width: 1,
      //                         )
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Text("${homeAddController
      //                           .checkData[0]["family_house_id"]["address"]},${homeAddController
      //                           .checkData[0]["family_house_id"]["city"]},${homeAddController
      //                           .checkData[0]["family_house_id"]["state"]},${homeAddController
      //                           .checkData[0]["family_house_id"]["country"]}",
      //                         style: Theme
      //                             .of(context)
      //                             .textTheme
      //                             .body1Regular
      //                             .copyWith(color: AppColors.text),),
      //                     ),
      //                   ),
      //                   Text("Pin Code", style: Theme
      //                       .of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),),
      //                   Container(
      //                     width: Get.width,
      //                     decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.circular(5),
      //                         color: AppColors.lightGrey,
      //                         border: Border.all(
      //                           color: AppColors.text,
      //                           width: 1,
      //                         )
      //                     ),
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Text("${homeAddController
      //                           .checkData[0]["family_house_id"]["pincode"]}",
      //                         style: Theme
      //                             .of(context)
      //                             .textTheme
      //                             .body1Regular
      //                             .copyWith(color: AppColors.text),),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //
      //           // Obx(() => Column(
      //           //   children: homeAddController.otherAddresses.asMap().entries.map((entry) {
      //           //     int index = entry.key;
      //           //     AddressModel data = entry.value;
      //           //     return Container(
      //           //       margin: const EdgeInsets.only(bottom: 18),
      //           //       decoration: BoxDecoration(
      //           //         color: AppColors.white,
      //           //         borderRadius: BorderRadius.circular(10),
      //           //         boxShadow: [
      //           //           BoxShadow(
      //           //             color: Color(0xff14453D33).withOpacity(0.2),
      //           //             blurRadius: 10,
      //           //           ),
      //           //         ],
      //           //       ),
      //           //       child: Padding(
      //           //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      //           //         child: Column(
      //           //           spacing: 8,
      //           //           crossAxisAlignment: CrossAxisAlignment.start,
      //           //           children: [
      //           //             Text(
      //           //               "Home Address ${index + 2}",
      //           //               style: GoogleFonts.nunito(
      //           //                   fontWeight: FontWeight.bold,
      //           //                   color: AppColors.text,
      //           //                   fontSize: 18
      //           //               ),
      //           //             ),
      //           //
      //           //             Text("Name",
      //           //                 style: Theme.of(context)
      //           //                     .textTheme
      //           //                     .bodyBold
      //           //                     .copyWith(color: AppColors.text)),
      //           //             Container(
      //           //               width: Get.width,
      //           //               decoration: BoxDecoration(
      //           //                   borderRadius: BorderRadius.circular(5),
      //           //                   color: AppColors.lightGrey,
      //           //                   border: Border.all(
      //           //                     color: AppColors.text,
      //           //                     width: 1,
      //           //                   )
      //           //               ),
      //           //               child: Padding(
      //           //                 padding: const EdgeInsets.all(8.0),
      //           //                 child: Text(data.name,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
      //           //               ),
      //           //             ),
      //           //             Text("Mobile No",
      //           //                 style: Theme.of(context)
      //           //                     .textTheme
      //           //                     .bodyBold
      //           //                     .copyWith(color: AppColors.text)),
      //           //             Container(
      //           //               width: Get.width,
      //           //               decoration: BoxDecoration(
      //           //                   borderRadius: BorderRadius.circular(5),
      //           //                   color: AppColors.lightGrey,
      //           //                   border: Border.all(
      //           //                     color: AppColors.text,
      //           //                     width: 1,
      //           //                   )
      //           //               ),
      //           //               child: Padding(
      //           //                 padding: const EdgeInsets.all(8.0),
      //           //                 child: Text(data.mobile,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
      //           //               ),
      //           //             ),
      //           //
      //           //             Text("Address",
      //           //                 style: Theme.of(context)
      //           //                     .textTheme
      //           //                     .bodyBold
      //           //                     .copyWith(color: AppColors.text)),
      //           //             Container(
      //           //               width: Get.width,
      //           //               decoration: BoxDecoration(
      //           //                   borderRadius: BorderRadius.circular(5),
      //           //                   color: AppColors.lightGrey,
      //           //                   border: Border.all(
      //           //                     color: AppColors.text,
      //           //                     width: 1,
      //           //                   )
      //           //               ),
      //           //               child: Padding(
      //           //                 padding: const EdgeInsets.all(8.0),
      //           //                 child: Text(data.relation,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
      //           //               ),
      //           //             ),
      //           //           ],
      //           //         ),
      //           //       ),
      //           //     );
      //           //   }).toList(),
      //           // )),
      //           InkWell(
      //             onTap: (){
      //               Get.bottomSheet(
      //                   isScrollControlled: true,
      //                   SingleChildScrollView(
      //                     padding: EdgeInsets.only(
      //                       bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
      //                     ),
      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                         color: AppColors.white,
      //                         borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
      //                       ),
      //                       child: Padding(
      //                           padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      //                           child: Form(
      //                             key: homeAddController.homeKey,
      //                             child: Column(
      //                               mainAxisSize: MainAxisSize.min,
      //                               spacing: 8,
      //                               children: [
      //                                 GestureDetector(
      //                                   onTap : (){
      //                                     Get.back();
      //                                   },
      //                                   child: Align(
      //                                     alignment: AlignmentGeometry.topRight,
      //                                     child: SvgPicture.string(AppSvgs.closeCircle,color: AppColors.red,),
      //                                   ),
      //                                 ),
      //                                 Obx(() => GestureDetector(
      //                                   onTap: (){
      //                                     homeAddController.profileImagePicker();
      //                                   },
      //                                   child: Container(
      //                                     height: 110,
      //                                     width: 110,
      //                                     decoration: BoxDecoration(
      //                                       shape: BoxShape.rectangle,
      //                                       color: homeAddController.profileImage.value.isNotEmpty ? AppColors.white:AppColors.text,
      //                                       borderRadius: BorderRadius.circular(10),
      //                                       image: homeAddController.profileImage.value.isNotEmpty
      //                                           ? DecorationImage(
      //                                         image: homeAddController.profileImage.value.startsWith("http")
      //                                             ? NetworkImage(homeAddController.profileImage.value)
      //                                             : FileImage(File(homeAddController.profileImage.value))
      //                                         as ImageProvider,
      //                                         fit: BoxFit.cover,
      //                                       )
      //                                           : null,
      //                                     ),
      //                                     child: homeAddController.profileImage.isEmpty
      //                                         ? Column(
      //                                       mainAxisAlignment: MainAxisAlignment.center,
      //                                       children: [
      //                                         SvgPicture.string(
      //                                           AppSvgs.user,
      //                                           color: AppColors.white,
      //                                           height: 40,
      //                                           width: 40,
      //                                         ),
      //                                         Text(
      //                                           "Upload Profile",
      //                                           style: Theme.of(context)
      //                                               .textTheme
      //                                               .body1Bold
      //                                               .copyWith(color: AppColors.white),
      //                                           textAlign: TextAlign.center,
      //                                         )
      //                                       ],
      //                                     )
      //                                         : SizedBox(),
      //                                   ),
      //                                 ),),
      //                                 Row(
      //                                   spacing: 8,
      //                                   children: [
      //                                     Expanded(
      //                                       child: AppTextFormField(labelText: "Name", controller: homeAddController.name),
      //                                     ),
      //                                     Expanded(child: AppDropDownSurname(surname: homeAddController.surname))
      //                                   ],
      //                                 ),
      //                                 Align(
      //                                     alignment: Alignment.centerLeft,
      //                                     child: Text("Relation",style: Theme.of(context).textTheme.body1Bold,)),
      //                                 SizedBox(
      //                                     height: 40,
      //                                     child: AppRadioButton(items: ["Brother","Son"], selectedIndex: 0)),
      //                                 AppTextFormField(labelText: "Mobile No.", controller: homeAddController.mobileNo),
      //                                 AppTextFormField(labelText: "Address", controller: homeAddController.address),
      //                                 AppTextFormField(labelText: "City", controller: homeAddController.city),
      //                                 AppTextFormField(labelText: "State", controller: homeAddController.state),
      //                                 AppTextFormField(labelText: "Country", controller: homeAddController.county),
      //                                 AppTextFormField(labelText: "Pin Code", controller: homeAddController.pinCode),
      //
      //                                 InkWell(
      //                                   onTap: () async {
      //                                     if(homeAddController.homeKey.currentState!.validate()){
      //                                       // homeAddController.addAddress();
      //                                       await homeAddController.homeAdd();
      //                                       Get.back();
      //                                     }
      //                                   },
      //                                   child: Container(
      //                                     height: 45,
      //                                     decoration: BoxDecoration(
      //                                       color: appColors.selectedColor.value,
      //                                       borderRadius: BorderRadius.circular(10),
      //                                     ),
      //                                     child: Center(child: homeAddController.add.value == true ? CircularProgressIndicator() :Text("Submit",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),),
      //                                   ),
      //                                 )
      //                               ],
      //                             ),)
      //                       ),
      //                     ),
      //                   ));
      //             },
      //             child: Container(
      //               height: 45,
      //               width: 200,
      //               decoration: BoxDecoration(
      //                   color: AppColors.white,
      //                   borderRadius: BorderRadius.circular(10),
      //                   border: Border.all(
      //                       color: appColors.selectedColor.value,
      //                       width: 1
      //                   )
      //               ),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   SvgPicture.string(AppSvgs.add,color: appColors.selectedColor.value,),
      //                   Text("Add Another Address",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),),
      //                 ],
      //               ),
      //             ),
      //           ),
      //
      //         ],
      //       ),
      //     );
      //   }
      // },),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
      //   child: InkWell(
      //     onTap: (){
      //       homeAddController.checkMember();
      //       Get.to(AddMemberUser(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
      //     },
      //     child: Container(
      //       height: 45,
      //       width: 200,
      //       decoration: BoxDecoration(
      //         color: appColors.selectedColor.value,
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //       child: Center(child: Text("Submit & Next",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),)),
      //     ),
      //   ),
      // ),
    );
  }
}
