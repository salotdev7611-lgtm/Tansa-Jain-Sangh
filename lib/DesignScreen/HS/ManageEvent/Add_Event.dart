import 'dart:io';

import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/TextFormFields/app_text_form_field.dart';
import 'Add_Event_Controller.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key, required this.eventId});
  final String eventId;
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final AppColors appColors = Get.put(AppColors());
  final AddEventController addEventController = Get.put(AddEventController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(addEventController.updateEvent.value == true ? "Update Event" : "Add Event",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Form(
            key: addEventController.eventKey,
            child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => InkWell(
                onTap: (){
                  addEventController.profileImagePicker();
                },
                child: Container(
                  height: 186,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.text,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: addEventController.event.value.isNotEmpty
                      ? (addEventController.event.value.startsWith("http")
                      ? Image.network(
                    addEventController.event.value,
                    fit: BoxFit.contain,
                  )
                      : Image.file(
                    File(addEventController.event.value),
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
                      ),
                    ],
                  ),
                ),
              ),),
              // AppTextFormField(labelText: "Organizer Name", controller: addEventController.organizerName),
              AppTextFormField(labelText: "Event Name", controller: addEventController.eventName,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please Enter Event Name";
                  }
                  return null;
                },
              ),
              AppTextFormField(labelText: "Location", controller: addEventController.location,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please Enter Location";
                  }
                  return null;
                },
              ),
              AppTextFormField(labelText: "Description", controller: addEventController.description, minLine: 3, maxLine: null,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please Enter Description";
                  }
                  return null;
                },
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(labelText: "Start date", controller: addEventController.startDate,  suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.string(AppSvgs.calenderColoredGujarati),
                      ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter start date";
                          }

                          // dd-mm-yyyy format
                          final RegExp dateRegex =
                          RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                          if (!dateRegex.hasMatch(value.trim())) {
                            return "valid format (DD-MM-YYYY)";
                          }

                          return null;
                        },
                      ),
                    ],
                  )),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: addEventController.startTime,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "enter hours";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              " : ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyBold
                                  .copyWith(color: AppColors.text),
                            ),

                            SizedBox(
                              height: 40,
                              width: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: addEventController.startMin,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "enter minutes";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.lightGrey,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                ),
                              ),
                              // child: AppTextFormField(
                              //   color: AppColors.lightGrey,
                              //   labelText: "",
                              //   controller: addEventController.startMin,
                              // ),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Obx(() => Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: appColors.selectedColor.value),
                                ),
                                child: Row(
                                  children: [

                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          addEventController.isAmSelected.value = true;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: addEventController.isAmSelected.value
                                                ? appColors.selectedColor.value
                                                : AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "AM",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyBold
                                                  .copyWith(
                                                color: addEventController.isAmSelected.value
                                                    ? AppColors.white
                                                    : appColors.selectedColor.value,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          addEventController.isAmSelected.value = false;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: !addEventController.isAmSelected.value
                                                ? appColors.selectedColor.value
                                                : AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "PM",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyBold
                                                  .copyWith(
                                                color: !addEventController.isAmSelected.value
                                                    ? AppColors.white
                                                    : appColors.selectedColor.value,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppTextFormField(labelText: "End date", controller: addEventController.endDate,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter start date";
                      }

                      // dd-mm-yyyy format
                      final RegExp dateRegex =
                      RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                      if (!dateRegex.hasMatch(value.trim())) {
                        return "valid format (DD-MM-YYYY)";
                      }

                      return null;
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.string(AppSvgs.calenderColoredGujarati),
                    ),)),
                  SizedBox(width: 16),

                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [

                            SizedBox(
                              height: 40,
                              width: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: addEventController.endTime,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "enter hours";
                                  }
                                 return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              " : ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyBold
                                  .copyWith(color: AppColors.text),
                            ),

                            SizedBox(
                              height: 40,
                              width: 50,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: addEventController.endMin,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return "enter minutes";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.lightGrey,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.text),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Obx(() => Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: appColors.selectedColor.value),
                                ),
                                child: Row(
                                  children: [

                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          addEventController.isPmSelected.value = true;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: addEventController.isPmSelected.value
                                                ? appColors.selectedColor.value
                                                : AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "AM",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyBold
                                                  .copyWith(
                                                color: addEventController.isPmSelected.value
                                                    ? AppColors.white
                                                    : appColors.selectedColor.value,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          addEventController.isPmSelected.value = false;
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: !addEventController.isPmSelected.value
                                                ? appColors.selectedColor.value
                                                : AppColors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "PM",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyBold
                                                  .copyWith(
                                                color: !addEventController.isPmSelected.value
                                                    ? AppColors.white
                                                    : appColors.selectedColor.value,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppTextFormField(labelText: "Live Link", controller: addEventController.liveLink,),

              Obx(() =>   InkWell(
                onTap: () async {
                  if (addEventController.eventKey.currentState!.validate()) {

                    if (addEventController.updateEvent.value == true) {
                      await addEventController.eventEdit(
                        context,
                        ID: widget.eventId,
                      );
                    } else {
                      await addEventController.eventAdd(context);
                    }

                  }
                },
                child: Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: appColors.selectedColor.value,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                    child: Center(
                      child: addEventController.add.value
                          ? CircularProgressIndicator()
                          :Text(addEventController.updateEvent.value == true ? "Update" : "Submit",
                        style:  Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),)
              // ActiveButton(
              //     height: 45,
              //     onTap: () async {
              //       if (addEventController.eventKey.currentState!.validate()) {
              //
              //         if (addEventController.updateEvent.value == true) {
              //           await addEventController.eventEdit(
              //             context,
              //             ID: widget.eventId,
              //           );
              //         } else {
              //           await addEventController.eventAdd(context);
              //         }
              //
              //       }
              //     }, text: addEventController.updateEvent.value == true ? "Update" : "Submit")

            ],
          ),)
        ),
      ),
    );
  }
}
