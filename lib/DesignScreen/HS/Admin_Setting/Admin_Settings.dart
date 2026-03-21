import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_field.dart';
import 'package:family_app/Widgets/DropDownFields/app_drop_down_surname.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../Helpers/app_colors.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {

  final AdminSettingController adminSettingController = Get.put(AdminSettingController());
  final AppColors appColors = Get.put(AppColors());
  bool _isExpanded = false;
  bool _isExpandeds = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Admin Settings",
          style: Theme.of(context)
              .textTheme
              .bodyBold
              .copyWith(color: AppColors.text),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Row(
      //         children: [
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   "Surname",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),
      //                 ),
      //                 const SizedBox(height: 8),
      //                 AppDropDownSurname(
      //                   surname: adminSettingController.surname,
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(width: 12),
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               children: [
      //                 Text(
      //                   "Profession",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .bodyBold
      //                       .copyWith(color: AppColors.text),
      //                 ),
      //                 const SizedBox(height: 8),
      //                 AppDropDownField(
      //                   profession: adminSettingController.profession,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //
      //       const SizedBox(height: 20),
      //
      //       Text(
      //         "Change Colour",
      //         style: Theme.of(context)
      //             .textTheme
      //             .bodyBold
      //             .copyWith(color: AppColors.text),
      //       ),
      //       const SizedBox(height: 8),
      //       Obx(() {
      //         final color = adminSettingController.selectedColor.value;
      //         final hex = adminSettingController.colorToHex(color);
      //
      //         return GestureDetector(
      //           onTap: () {
      //             Get.dialog(
      //               AlertDialog(
      //                 backgroundColor: AppColors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.only(topRight: Radius.circular(150),topLeft: Radius.circular(150),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
      //                 ),
      //                 contentPadding: const EdgeInsets.all(16),
      //                 content: SingleChildScrollView(
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       // HueRingPicker(
      //                       //   pickerColor: color, onColorChanged: (value) {
      //                       //   adminSettingController.changeColor(value);
      //                       // },
      //                       //   enableAlpha: false,
      //                       //   pickerAreaBorderRadius: BorderRadius.circular(12),
      //                       // ),
      //                       /// 🎨 ROUND COLOR WHEEL
      //                       ColorPicker(
      //                         pickerColor: color,
      //                         onColorChanged: (c) {
      //                           adminSettingController.changeColor(c);
      //                         },
      //                         pickerAreaHeightPercent: 0.8,
      //                         enableAlpha: false,
      //                         labelTypes: const [],
      //                         paletteType: PaletteType.hueWheel,
      //                         pickerAreaBorderRadius: BorderRadius.circular(12),
      //                       ),
      //
      //                       const SizedBox(height: 16),
      //
      //                       /// 🟡 COLOR + HEX ROW
      //                       Row(
      //                         children: [
      //                           Container(
      //                             height: 24,
      //                             width: 24,
      //                             decoration: BoxDecoration(
      //                               shape: BoxShape.circle,
      //                               color: color,
      //                             ),
      //                           ),
      //                           const SizedBox(width: 12),
      //                           Text(
      //                             "Hex",
      //                             style: Theme.of(context).textTheme.bodyBold,
      //                           ),
      //                           const SizedBox(width: 8),
      //                           Expanded(
      //                             child: Text(
      //                               hex,
      //                               style: Theme.of(context)
      //                                   .textTheme
      //                                   .bodyRegular
      //                                   .copyWith(color: AppColors.text),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 actions: [
      //                   TextButton(
      //                     onPressed: () => Get.back(),
      //                     child: const Text("Cancel"),
      //                   ),
      //                   ElevatedButton(
      //                     onPressed: () {
      //                       adminSettingController.saveThemeColor();
      //                       Get.back();
      //                     },
      //                     child: const Text("Save"),
      //                   ),
      //                 ],
      //               ),
      //             );
      //           },
      //
      //           /// 🔵 PREVIEW BUTTON
      //           child: Container(
      //             height: 50,
      //             padding: const EdgeInsets.symmetric(horizontal: 12),
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(12),
      //               border: Border.all(color: AppColors.buttonColor),
      //             ),
      //             child: Row(
      //               children: [
      //                 Container(
      //                   height: 28,
      //                   width: 28,
      //                   decoration: BoxDecoration(
      //                     shape: BoxShape.circle,
      //                     color: color,
      //                   ),
      //                 ),
      //                 const SizedBox(width: 12),
      //                 Text(
      //                   hex,
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .bodyRegular
      //                       .copyWith(color: AppColors.text),
      //                 ),
      //                 const Spacer(),
      //                 const Icon(Icons.color_lens_outlined),
      //               ],
      //             ),
      //           ),
      //         );
      //       }),
      //
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
          decoration: BoxDecoration(
          color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff14453D4D).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Obx(() => ExpansionTile(
            backgroundColor: AppColors.white,
            collapsedBackgroundColor: AppColors.white,
            title: Row(
              children: [
                Text(
                  "Surname",
                  style: Theme.of(context)
                      .textTheme
                      .bodyBold
                      .copyWith(color: AppColors.text),
                ),
                Spacer(),
                GestureDetector(
                    onTap: (){
                      adminSettingController.getSurname();
                      adminSettingController.updates.value = (-1);
                      Get.bottomSheet(Container(
                          height: 450,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Surname List",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                      GestureDetector(
                                        onTap: (){
                                          adminSettingController.addSurname.clear();
                                          Get.back();
                                          Get.dialog(Dialog(
                                            child: Container(
                                              height: 200,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                                child: Column(
                                                  spacing: 16,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        Text("Add Surname",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                                        Spacer(),
                                                        GestureDetector(
                                                            onTap: (){
                                                              Get.back();
                                                            },
                                                            child: SvgPicture.string(AppSvgs.closeCircle,height: 35,color: AppColors.red,)),
                                                      ],
                                                    ),
                                                    Form(
                                                        key: adminSettingController.surnameKey,
                                                        child: AppTextFormField(labelText: "Surname", controller: adminSettingController.addSurname,
                                                          validator: (value){
                                                            if(value == null || value.isEmpty){
                                                              return "Please Enter Surname";
                                                            }
                                                            return null;
                                                          },
                                                        )),
                                                    GestureDetector(
                                                      onTap: ()async{
                                                        if(adminSettingController.surnameKey.currentState!.validate()) {
                                                          await adminSettingController.addSurnames(context);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                          color: appColors.selectedColor.value,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Center(
                                                          child: Text("Add",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        },
                                        child: SvgPicture.string(AppSvgs.addCircleFilled,height: 35,),
                                      ),
                                    ],
                                  ),
                                  Obx((){
                                    if(adminSettingController.get.value){
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );

                                    }
                                    if(adminSettingController.listOfSurname.isEmpty){
                                      return Text("No Surname Is Add..");
                                    }
                                    else {
                                      return Expanded(
                                        child: ListView.builder(
                                          itemCount: adminSettingController.listOfSurname.length,
                                          itemBuilder: (context, index) {
                                            return Obx(() => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              child: TextFormField(
                                                focusNode: adminSettingController.activeIndex.value == index ? adminSettingController.focusNode : null,
                                                style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                                                controller: adminSettingController.surname[index],
                                                decoration: InputDecoration(
                                                  labelText: "Surname",
                                                  labelStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                                                  suffixIcon: Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Row(
                                                      spacing: 6,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            /// focus is on
                                                            adminSettingController.focusAt(index);
                                                          },
                                                          child: SvgPicture.string(AppSvgs.edit1),
                                                        ),

                                                        Visibility(
                                                          visible: adminSettingController.updates.value != index,
                                                          child:  GestureDetector(
                                                            onTap: () {
                                                              Get.back();
                                                              adminSettingController.deleteSurnames.value = adminSettingController.listOfSurname[index]["surname"];
                                                              print("adminSettingController.deleteSurname.value ${adminSettingController.deleteSurnames.value}");
                                                              Get.dialog(
                                                                Dialog(
                                                                  child: Container(
                                                                    height: 180,
                                                                    width: Get.width,
                                                                    decoration: BoxDecoration(
                                                                      color: AppColors.white,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                                                      child: Column(
                                                                        spacing: 8,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Spacer(),
                                                                              Text("Delete Dialog",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                                                                              Spacer(),
                                                                              GestureDetector(
                                                                                  onTap: (){
                                                                                    Get.back();
                                                                                  },
                                                                                  child: SvgPicture.string(AppSvgs.closeCircle,height: 35,color: AppColors.red,)),
                                                                            ],
                                                                          ),
                                                                          Text("You Wont to Delete This Surname?.",style: Theme.of(context).textTheme.bodyRegular.copyWith(color: AppColors.text),),
                                                                          Text(adminSettingController.listOfSurname[index]["surname"],style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                                                          Align(
                                                                            alignment: Alignment.bottomRight,
                                                                            child: GestureDetector(
                                                                              onTap: (){

                                                                                adminSettingController.deleteSurnames.value = adminSettingController.listOfSurname[index]["surname"];
                                                                                print("adminSettingController.deleteSuename.value ${adminSettingController.deleteSurnames.value}");
                                                                                print("index ${index}");
                                                                                adminSettingController.deleteSurname(context, surname: adminSettingController.deleteSurnames.value);
                                                                                // adminSettingController.removeSurname(index);
                                                                                print("index ${index}");
                                                                              },
                                                                              child: Container(
                                                                                height: 35,
                                                                                width: 90,
                                                                                decoration: BoxDecoration(
                                                                                  color: appColors.selectedColor.value,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text("Delete",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            //               adminSettingController.deleteSuename.value = adminSettingController.listOfSurname[index]["surname"];
                                                            //               print("adminSettingController.deleteSuename.value ${adminSettingController.deleteSuename.value}");
                                                            //             print("index ${index}");
                                                            //   adminSettingController.deleteSurname(context, surname: adminSettingController.deleteSuename.value);
                                                            // // adminSettingController.removeSurname(index);
                                                            // print("index ${index}");
                                                            child: SvgPicture.string(AppSvgs.deleteFilled),
                                                          ),),
                                                        Visibility(
                                                            visible: adminSettingController.updates.value == index,
                                                            child: GestureDetector(
                                                                onTap: () async {
                                                                  adminSettingController.old_surname.value = adminSettingController.listOfSurname[index]["surname"];
                                                                  print("adminSettingController.old_surname.value ${adminSettingController.old_surname.value.toString()}");
                                                                  await adminSettingController.editSurname(context, index, oldSurname: adminSettingController.old_surname.value,);
                                                                },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: appColors.selectedColor.value,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Center(child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text("Update",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                                                    ))))),
                                                      ],
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: AppColors.text),
                                                  ),
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
                                                  errorStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.red),
                                                ),
                                                onChanged: (value){
                                                  adminSettingController.updates.value = index;
                                                },
                                              ),
                                            ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  }),
                                ]
                            ),
                          )));
                    },
                    child: SvgPicture.string(AppSvgs.edit1))
              ],
            ),
            initiallyExpanded: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onExpansionChanged: (bool value) {
              setState(() {
                _isExpandeds = value;
                adminSettingController.getSurname();
              });
            },
            trailing: Icon(
              _isExpandeds
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children:[
                    ...List.generate(adminSettingController.listOfSurname.length, (index) {
                      final surname = adminSettingController.listOfSurname[index];
                      return Container(
                        width: 130,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: appColors.selectedColor.value,
                            )
                        ),
                        child: Text(surname["surname"].toString(),
                          style:  Theme.of(context).textTheme.bodyRegular.copyWith(color: appColors.selectedColor.value),
                        ),
                      );
                    },),
                  //   GridView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: adminSettingController.listOfSurname.length,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 3,
                  //     crossAxisSpacing: 10,
                  //     mainAxisSpacing: 10,
                  //     childAspectRatio: 4,
                  //   ),
                  //   itemBuilder: (context, index) {
                  //
                  //   },
                  // ),
            ]
                ),
              ),
            ],
          ),)
        ),

              Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff14453D4D).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Obx(() => ExpansionTile(
                    backgroundColor: AppColors.white,
                    collapsedBackgroundColor: AppColors.white,
                    title: Row(
                      children: [
                        Text(
                          "Profession",
                          style: Theme.of(context)
                              .textTheme
                              .bodyBold
                              .copyWith(color: AppColors.text),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: (){
                              adminSettingController.updates.value = (-1);
                              adminSettingController.getProfession();
                              adminSettingController.addProfession.clear();
                              Get.bottomSheet(Container(
                                  height: 450,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Profession List",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                              GestureDetector(
                                                onTap: (){
                                                  Get.back();
                                                  Get.dialog(Dialog(
                                                    child: Container(
                                                      height: 200,
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                        color: AppColors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                                        child: Column(
                                                          spacing: 16,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Spacer(),
                                                                Text("Add Profession",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                                                Spacer(),
                                                                GestureDetector(
                                                                    onTap: (){
                                                                      Get.back();
                                                                    },
                                                                    child: SvgPicture.string(AppSvgs.closeCircle,height: 35,color: AppColors.red,)),
                                                              ],
                                                            ),
                                                            Form(
                                                                key: adminSettingController.professionKey,
                                                                child: AppTextFormField(labelText: "Profession", controller: adminSettingController.addProfession,
                                                                  validator: (value){
                                                                    if(value == null || value.isEmpty){
                                                                      return "Please Enter Profession";
                                                                    }
                                                                    else{
                                                                      return null;
                                                                    }
                                                                  },
                                                                )),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if(adminSettingController.professionKey.currentState!.validate()){
                                                                  adminSettingController.addProfessions(context);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: 150,
                                                                decoration: BoxDecoration(
                                                                  color: appColors.selectedColor.value,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Center(
                                                                  child: Text("Add",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                                },
                                                child: SvgPicture.string(AppSvgs.addCircleFilled,height: 35,),
                                              ),
                                            ],
                                          ),
                                          Obx((){
                                            if(adminSettingController.get.value){
                                              return CircularProgressIndicator();
                                            }
                                            if(adminSettingController.listOfProfession.isEmpty){
                                              return Text("No Profession Are Add");
                                            }
                                            else{
                                              return Expanded(
                                                child: ListView.builder(
                                                  itemCount: adminSettingController.listOfProfession.length,
                                                  itemBuilder: (context, index) {
                                                    return Obx(() => Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                      child: TextFormField(
                                                        focusNode:
                                                        adminSettingController.activeIndex.value == index
                                                            ? adminSettingController.focusNode
                                                            : null,
                                                        style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                                                        controller: adminSettingController.profession[index],
                                                        decoration: InputDecoration(
                                                          labelText: "Profession",
                                                          labelStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                                                          suffixIcon: Padding(
                                                            padding: const EdgeInsets.all(4),
                                                            child: Row(
                                                              spacing: 6,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    /// focus is on
                                                                    adminSettingController.focusAt(index);
                                                                  },
                                                                  child: SvgPicture.string(AppSvgs.edit1),
                                                                ),
                                                                Visibility(
                                                                  visible: adminSettingController.updates.value != index,
                                                                  child:  GestureDetector(
                                                                    onTap: () {
                                                                      adminSettingController.deleteProfession.value = adminSettingController.listOfProfession[index]["name"];
                                                                      print("index ${adminSettingController.deleteProfession.value}");
                                                                      adminSettingController.professionDelete(context, profession: adminSettingController.deleteProfession.value);
                                                                      // adminSettingController.removeProfession(index);
                                                                      print("index ${index}");
                                                                    },
                                                                    child: SvgPicture.string(AppSvgs.deleteFilled),
                                                                  ),),
                                                                Visibility(
                                                                    visible: adminSettingController.updates.value == index,
                                                                    child: GestureDetector(
                                                                        onTap: (){
                                                                          adminSettingController.deleteProfession.value = adminSettingController.listOfProfession[index]["name"];
                                                                          adminSettingController.editProfession(context, index, oldProfession: adminSettingController.deleteProfession.value);
                                                                        },
                                                                        child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: appColors.selectedColor.value,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Center(child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text("Update",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                                                            ))))),
                                                              ],
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                            borderSide: BorderSide(color: AppColors.text),
                                                          ),
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
                                                          errorStyle: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.red),
                                                        ),
                                                        onChanged: (value){
                                                          adminSettingController.updates.value = index;
                                                        },
                                                      ),
                                                    ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                          }),
                                        ]
                                    ),
                                  )));},
                            child: SvgPicture.string(AppSvgs.edit1)),
                      ],
                    ),
                    initiallyExpanded: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onExpansionChanged: (bool value) {
                      setState(() {
                        _isExpanded = value;
                        adminSettingController.getProfession();
                      });
                    },
                    trailing: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children:[
                              ...List.generate(adminSettingController.listOfProfession.length, (index) {
                                final professionName =adminSettingController.listOfProfession[index];
                                return Container(
                                  width: 130,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: appColors.selectedColor.value,
                                      )
                                  ),
                                  child: Text(professionName["name"].toString(),
                                    style:  Theme.of(context).textTheme.bodyRegular.copyWith(color: appColors.selectedColor.value),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },),
                            ]
                        ),
                      ),
                    ],
                  ),)
                ),

              Obx(() {
                final color = adminSettingController.selectedColor.value;
                final hex = adminSettingController.colorToHex(color);
                return  GestureDetector(
                  onTap: (){
                    Get.bottomSheet(
                        Container(
                          height: 450,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: SvgPicture.string(AppSvgs.closeCircle,color: AppColors.red,)),
                                ),
                                ColorPicker(
                                  pickerColor: color,
                                  onColorChanged: (c) {
                                    adminSettingController.changeColor(c);
                                  },
                                  pickerAreaHeightPercent: 0.8,
                                  enableAlpha: false,
                                  labelTypes: const [],
                                  paletteType: PaletteType.hueWheel,
                                  pickerAreaBorderRadius: BorderRadius.circular(12),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Hex",
                                      style: Theme.of(context).textTheme.bodyBold,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        hex,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyRegular
                                            .copyWith(color: AppColors.text),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap : (){
                                        adminSettingController.changeTheme(context);
                                        Get.back();
                                      },
                                      child:  Container(
                                        height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: appColors.selectedColor.value,
                                            borderRadius: BorderRadius.circular(10),

                                          ),
                                          child: Center(child: Text("Save",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),))),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ));
                  },
                  child: Container(
                    width: Get.width,
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff14453D4D).withValues(alpha: 0.4),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Theme Color", style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text)),
                          Row(
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                hex,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyRegular
                                    .copyWith(color: AppColors.text),
                              ),

                            ],
                          ),                      ],
                      ),
                    ),
                  ),
                );
              },),

              Container(
                height: 56,
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff14453D4D).withValues(alpha: 0.4),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chat", style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text)),
                      Obx(() =>  FlutterSwitch(
                          width: 70.0,
                          height: 35.0,
                          valueFontSize: 16.0,
                          toggleSize: 30.0,
                          value: adminSettingController.status.value,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          activeColor: appColors.selectedColor.value,
                          onToggle: (value){
                              adminSettingController.status.value = value;
                              adminSettingController.chatButton(chat: value);
                          }),)
                      // Switch(
                      //   value: _isSwitched, // The current boolean value of the switch
                      //   onChanged: (newValue) { // Callback when the user toggles the switch
                      //     setState(() {
                      //       _isSwitched = newValue; // Update the state
                      //     });
                      //   },
                      //   activeColor: appColors.selectedColor.value, // Optional: color when the switch is ON
                      // )
                      // Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.text,)
                    ],
                  ),
                ),
              ),

              Container(
                height: 56,
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff14453D4D).withValues(alpha: 0.4),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Post", style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text)),
                      Obx(() =>  FlutterSwitch(
                          width: 70.0,
                          height: 35.0,
                          valueFontSize: 16.0,
                          toggleSize: 30.0,
                          value: adminSettingController.post.value,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          activeColor: appColors.selectedColor.value,
                          onToggle: (value){
                            adminSettingController.post.value = value;
                            adminSettingController.postButton(post: value);
                            print("value ${value}");
                          }),)
                      // Switch(
                      //   value: _isSwitched, // The current boolean value of the switch
                      //   onChanged: (newValue) { // Callback when the user toggles the switch
                      //     setState(() {
                      //       _isSwitched = newValue; // Update the state
                      //     });
                      //   },
                      //   activeColor: appColors.selectedColor.value, // Optional: color when the switch is ON
                      // )
                      // Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.text,)
                    ],
                  ),
                ),
              ),


              Container(
                height: 56,
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff14453D4D).withValues(alpha: 0.4),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment", style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text)),
                      Obx(() =>  FlutterSwitch(
                          width: 70.0,
                          height: 35.0,
                          valueFontSize: 16.0,
                          toggleSize: 30.0,
                          value: adminSettingController.payment.value,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          activeColor: appColors.selectedColor.value,
                          onToggle: (value){
                            adminSettingController.payment.value = value;
                            adminSettingController.paymentButton(payment: value);
                            print("value ${value}");
                          }),)
                      // Switch(
                      //   value: _isSwitched, // The current boolean value of the switch
                      //   onChanged: (newValue) { // Callback when the user toggles the switch
                      //     setState(() {
                      //       _isSwitched = newValue; // Update the state
                      //     });
                      //   },
                      //   activeColor: appColors.selectedColor.value, // Optional: color when the switch is ON
                      // )
                      // Icon(Icons.keyboard_arrow_down_outlined,color: AppColors.text,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
