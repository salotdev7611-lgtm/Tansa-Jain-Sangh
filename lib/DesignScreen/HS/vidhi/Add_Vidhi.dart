import 'dart:io';

import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddVidhi extends StatefulWidget {
  const AddVidhi({super.key, required this.id});
  final String id;

  @override
  State<AddVidhi> createState() => _AddVidhiState();
}

class _AddVidhiState extends State<AddVidhi> {

  final AppColors appColors = Get.put(AppColors());
  final AddVidhiController addVidhiController = Get.put(AddVidhiController());
  final AdminSettingController adminSettingController = Get.put(AdminSettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminSettingController.getSurname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text(addVidhiController.vidhiUpdate.value == true ? "Edit Vidhi" :"Add Vidhi",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => InkWell(
                onTap: () {
                  addVidhiController.profileImagePicker();
                },
                child: Container(
                  height: 186,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: addVidhiController.vidhiImage.value.isNotEmpty
                      ? (addVidhiController.vidhiImage.value.startsWith("http")
                      ? Image.network(
                    addVidhiController.vidhiImage.value,
                    fit: BoxFit.contain,
                  )
                      : Image.file(
                    File(addVidhiController.vidhiImage.value),
                    fit: BoxFit.contain,
                  ))
                      : Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(
                        AppSvgs.uploadImage1,
                        color: AppColors.white,
                        height: 30,
                        width: 30,
                      ),
                      Text(
                        "Upload Image",
                        style: Theme.of(context)
                            .textTheme
                            .body1Bold
                            .copyWith(color: AppColors.white),
                      )
                    ],
                  ),
                ),
              ),),
              AppDropDownSurname(surname: addVidhiController.surname),
              AppTextFormField(labelText: "Title", controller: addVidhiController.title),
              AppTextFormField(labelText: "Tithi/Date ", controller: addVidhiController.tithiDate),
              AppTextFormField(labelText: "Short Description", controller: addVidhiController.description, minLine: 3,      // starting height (3 lines)
                maxLine: null, ),
              // Text("When to Perform?",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              // Row(
              //   spacing: 12,
              //   children: [
              //     Expanded(child: AppTextFormField(labelText: "Start date", controller: addVidhiController.startDate,  suffixIcon: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: SvgPicture.string(AppSvgs.calenderColoredGujarati),
              //     ),)),
              //     Expanded(child: AppTextFormField(labelText: "End date", controller: addVidhiController.endDate,  suffixIcon: Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: SvgPicture.string(AppSvgs.calenderColoredGujarati),
              //     ),)), ],
              // ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //
              //     Flexible(
              //       fit: FlexFit.tight,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "Start Time",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyRegular
              //                 .copyWith(color: AppColors.text),
              //           ),
              //           SizedBox(height: 4),
              //
              //           Row(
              //             children: [
              //
              //               SizedBox(
              //                 width: 45,
              //                 child: AppTextFormField(
              //                   labelText: "",
              //                   controller: addVidhiController.startTime,
              //                 ),
              //               ),
              //
              //               Text(
              //                 " : ",
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodyBold
              //                     .copyWith(color: AppColors.text),
              //               ),
              //
              //               SizedBox(
              //                 width: 45,
              //                 child: AppTextFormField(
              //                   color: AppColors.lightGrey,
              //                   labelText: "",
              //                   controller: addVidhiController.startTimeMin,
              //                 ),
              //               ),
              //
              //               SizedBox(width: 10),
              //
              //               Expanded(
              //                 child: Obx(() => Container(
              //                   height: 40,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(8),
              //                     border: Border.all(color: appColors.selectedColor.value),
              //                   ),
              //                   child: Row(
              //                     children: [
              //
              //                       Expanded(
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             addVidhiController.isAmSelected.value = true;
              //                           },
              //                           child: Container(
              //                             decoration: BoxDecoration(
              //                               color: addVidhiController.isAmSelected.value
              //                                   ? appColors.selectedColor.value
              //                                   : AppColors.white,
              //                               borderRadius: BorderRadius.only(
              //                                 topLeft: Radius.circular(8),
              //                                 bottomLeft: Radius.circular(8),
              //                               ),
              //                             ),
              //                             child: Center(
              //                               child: Text(
              //                                 "AM",
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodyBold
              //                                     .copyWith(
              //                                   color: addVidhiController.isAmSelected.value
              //                                       ? AppColors.white
              //                                       : appColors.selectedColor.value,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //
              //                       Expanded(
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             addVidhiController.isAmSelected.value = false;
              //                           },
              //                           child: Container(
              //                             decoration: BoxDecoration(
              //                               color: !addVidhiController.isAmSelected.value
              //                                   ? appColors.selectedColor.value
              //                                   : AppColors.white,
              //                               borderRadius: BorderRadius.only(
              //                                 topRight: Radius.circular(8),
              //                                 bottomRight: Radius.circular(8),
              //                               ),
              //                             ),
              //                             child: Center(
              //                               child: Text(
              //                                 "PM",
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodyBold
              //                                     .copyWith(
              //                                   color: !addVidhiController.isAmSelected.value
              //                                       ? AppColors.white
              //                                       : appColors.selectedColor.value,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 )),
              //               ),
              //
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //
              //     SizedBox(width: 16),
              //
              //     Flexible(
              //       fit: FlexFit.tight,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "End Time",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .bodyRegular
              //                 .copyWith(color: AppColors.text),
              //           ),
              //           SizedBox(height: 4),
              //
              //           Row(
              //             children: [
              //
              //               SizedBox(
              //                 width: 45,
              //                 child: AppTextFormField(
              //                   labelText: "",
              //                   controller: addVidhiController.endTime,
              //                 ),
              //               ),
              //
              //               Text(
              //                 " : ",
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodyBold
              //                     .copyWith(color: AppColors.text),
              //               ),
              //
              //               SizedBox(
              //                 width: 45,
              //                 child: AppTextFormField(
              //                   color: AppColors.lightGrey,
              //                   labelText: "",
              //                   controller: addVidhiController.endTimeMin,
              //                 ),
              //               ),
              //
              //               SizedBox(width: 10),
              //
              //               Expanded(
              //                 child: Obx(() => Container(
              //                   height: 40,
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(8),
              //                     border: Border.all(color: appColors.selectedColor.value),
              //                   ),
              //                   child: Row(
              //                     children: [
              //
              //                       Expanded(
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             addVidhiController.isPmSelected.value = true;
              //                           },
              //                           child: Container(
              //                             decoration: BoxDecoration(
              //                               color: addVidhiController.isPmSelected.value
              //                                   ? appColors.selectedColor.value
              //                                   : AppColors.white,
              //                               borderRadius: BorderRadius.only(
              //                                 topLeft: Radius.circular(8),
              //                                 bottomLeft: Radius.circular(8),
              //                               ),
              //                             ),
              //                             child: Center(
              //                               child: Text(
              //                                 "AM",
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodyBold
              //                                     .copyWith(
              //                                   color: addVidhiController.isPmSelected.value
              //                                       ? AppColors.white
              //                                       : appColors.selectedColor.value,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //
              //                       Expanded(
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             addVidhiController.isPmSelected.value = false;
              //                           },
              //                           child: Container(
              //                             decoration: BoxDecoration(
              //                               color: !addVidhiController.isPmSelected.value
              //                                   ? appColors.selectedColor.value
              //                                   : AppColors.white,
              //                               borderRadius: BorderRadius.only(
              //                                 topRight: Radius.circular(8),
              //                                 bottomRight: Radius.circular(8),
              //                               ),
              //                             ),
              //                             child: Center(
              //                               child: Text(
              //                                 "PM",
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodyBold
              //                                     .copyWith(
              //                                   color: !addVidhiController.isPmSelected.value
              //                                       ? AppColors.white
              //                                       : appColors.selectedColor.value,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 )),
              //               ),
              //
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // AppTextFormField(labelText: "Which Day?", controller: addVidhiController.whichDay),
              // AppTextFormField(labelText: "Which Time?", controller: addVidhiController.whichTime),

              Text("Pooja Essentials",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              Obx(() => Column(
                children: [
                  ...List.generate(addVidhiController.pujaEssentials.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextFormField(
                              labelText: "Puja Essentials",
                              controller: addVidhiController.pujaEssentials[index],
                            ),
                          ),

                          SizedBox(width: 8),

                          if (index > 0)
                            GestureDetector(
                              onTap: () {
                                addVidhiController.removePlace(index);
                              },
                              child: Icon(Icons.close, color: Colors.red),
                            )

                          else
                            GestureDetector(
                              onTap: () {
                                addVidhiController.addPlace();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appColors.selectedColor.value,
                                ),
                                padding: EdgeInsets.all(4),
                                child: SvgPicture.string(
                                  AppSvgs.add,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              )),

             //  Text("Ritual Steps",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
             //  Obx(() => Column(
             //   children: [
             //     ...List.generate(addVidhiController.ritualStepsDescription.length, (index) {
             //       return Padding(
             //         padding : const EdgeInsets.only(bottom: 8),
             //         child: Column(
             //           spacing: 8,
             //           children: [
             //             AppTextFormField(labelText: "Title", controller: addVidhiController.ritualStepsTitle[index]),
             //             Row(
             //               spacing: 8,
             //               children: [
             //                 Expanded(child: AppTextFormField(labelText: "Description", controller: addVidhiController.ritualStepsDescription[index])),
             //
             //                 if(index > 0)
             //                   GestureDetector(
             //                     onTap: () {
             //                       addVidhiController.removeAll(index);
             //                     },
             //                     child: Icon(Icons.close, color: Colors.red),
             //                   )
             //
             //                 else
             //                   GestureDetector(
             //                     onTap: () {
             //                       addVidhiController.addPlaceOne();
             //                     },
             //                     child: Container(
             //                       decoration: BoxDecoration(
             //                         shape: BoxShape.circle,
             //                         color: appColors.selectedColor.value,
             //                       ),
             //                       padding: EdgeInsets.all(4),
             //                       child: SvgPicture.string(
             //                         AppSvgs.add,
             //                         color: AppColors.white,
             //                       ),
             //                     ),
             //                   ),
             //               ],
             //             ),
             //           ],
             //         ),
             //       );
             //     },)
             //   ],
             // ),),
              // Text("Recipes Step",),
              // Obx(() => Column(
              //   children: [
              //     ...List.generate(addVidhiController.recipesSteps.length, (index) {
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 8),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: AppTextFormField(
              //                 labelText: "Recipes",
              //                 controller: addVidhiController.recipesSteps[index],
              //               ),
              //             ),
              //
              //             SizedBox(width: 8),
              //
              //             if (index > 0)
              //               GestureDetector(
              //                 onTap: () {
              //                   addVidhiController.removeRecipe(index);
              //                 },
              //                 child: Icon(Icons.close, color: Colors.red),
              //               )
              //
              //             else
              //               GestureDetector(
              //                 onTap: () {
              //                   addVidhiController.recipesAdd();
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                     shape: BoxShape.circle,
              //                     color: appColors.selectedColor.value,
              //                   ),
              //                   padding: EdgeInsets.all(4),
              //                   child: SvgPicture.string(
              //                     AppSvgs.add,
              //                     color: AppColors.white,
              //                   ),
              //                 ),
              //               ),
              //           ],
              //         ),
              //       );
              //     }),
              //   ],
              // )),
              
              Text("Description",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              Obx(() => Column(
                children: [
                  ...List.generate(addVidhiController.cookingDescription.length, (index) {
                    return Padding(
                      padding : const EdgeInsets.only(bottom: 8),
                      child: Column(
                        spacing: 8,
                        children: [
                          Row(

                            spacing: 8,

                            children: [
                              Expanded(child: AppTextFormField(labelText: "Title", controller: addVidhiController.cookingTitle[index])),
                              if (index == addVidhiController.cookingDescription.length - 1)
                                GestureDetector(
                                  onTap: () {
                                    addVidhiController.cooking(); // add new field
                                  },
                                  child: Container(
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appColors.selectedColor.value,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: SvgPicture.string(
                                      AppSvgs.add,
                                      color: AppColors.white,
                                    ),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    addVidhiController.removeCooking(index);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),

                          AppTextFormField(
                            labelText: "Description",
                            controller: addVidhiController.cookingDescription[index],
                            minLine: 3,      // starting height (3 lines)
                            maxLine: null,   // auto grow (no scroll)
                          ),

                        ],
                      ),
                    );
                  },)
                ],
              ),),

              Center(
                child: ActiveButton(
                    height: 45,
                    width: Get.width,
                    onTap: ()async{
                       if(addVidhiController.vidhiUpdate == true){
                         addVidhiController.editVidhi(context, id: widget.id);
                       }
                       else{
                         addVidhiController.addVidhi(context);
                       }
                    }, text: addVidhiController.vidhiUpdate == true ? "Update" :"Submit"),
              ),
              SizedBox(height: 20,)

            ],
          ),
        ),
      ),
    );
  }
}
