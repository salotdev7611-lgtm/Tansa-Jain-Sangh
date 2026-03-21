import 'dart:io';

import 'package:family_app/DesignScreen/HS/Chat/Group_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/Checkboxes/app_check_box.dart';
import 'package:family_app/Widgets/TextFormFields/app_searchbar.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final AppColors appColors = Get.put(AppColors());

final GroupController groupController = Get.put(GroupController());

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupController.getMember();
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
        title: Text("Select Member",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                controller: groupController.search,
                onChanged: (value){
                  groupController.filterMember(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,),
                  filled: true,
                  fillColor: AppColors.grey.withValues(alpha: 0.1),
                  contentPadding: EdgeInsets.only(left: 1,right: 12,bottom: 6),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color:AppColors.grey.withValues(alpha: 0.1),),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.1),),
                  ),
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.1),),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.1),),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.1),),
                  ),
                  hintText: "Search here...",
                  hintStyle: Theme.of(context).textTheme.bodyRegular,

                )
            ),
            Expanded(
              child: Obx(() {
                if(groupController.get.value){
                  return Center(child: CircularProgressIndicator());
                }
                else if(groupController.listOfFilterMember.isEmpty){
                  return Center(child: Text("No Member Found",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),));
                }
                else {
                  return ListView.builder(
                    // shrinkWrap: true,
                    itemCount:  groupController.listOfFilterMember.length,
                    itemBuilder: (context, index) {
                      final member =  groupController.listOfFilterMember[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6,top: 12),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: appColors.selectedColor.value.withValues(alpha: 0.3),
                                  offset: const Offset(0, 0),
                                  blurRadius: 5,
                                  spreadRadius: 0
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            spacing: 12,
                            children: [
                              SizedBox(width: 0,),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.white,
                                  image: DecorationImage(
                                    image: (member["profile_img"] != null &&
                                        member["profile_img"].toString().isNotEmpty)
                                        ? NetworkImage(member["profile_img"])
                                        : const AssetImage("assets/images/no-image.png")
                                    as ImageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Text("${member["name"]} ${member["surname"]}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                              Spacer(),
                              Obx(() => AppCheckBox(
                                isChecked: groupController.memberId.contains(
                                  member["id"].toString(),
                                ),
                                onTap: () {
                                  final id = member["id"].toString();
                                  if (groupController.memberId.contains(id)) {
                                    groupController.memberId.remove(id); // UNCHECK
                                  } else {
                                    groupController.memberId.add(id); // CHECK
                                  }
                                  print("Selected Members: ${groupController.memberId}");
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    },);
                }
              },)
            )

          ],
        ),
      ),
      floatingActionButton: ActiveIconButton(onTap: (){
        groupController.group.clear();
        groupController.groupImage.value = "";
        groupController.memberId.length <= 2
            ?  ScaffoldMessenger.of(Get.context!).showSnackBar(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Error",style: Theme.of(Get.context!).textTheme.bodyBold.copyWith(color: AppColors.white),),
                        Text("Please Select One More Member",style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                      ],
                    ),
                  ),
                )))
            : Get.dialog(Dialog(
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                width: 1,
                color: appColors.selectedColor.value
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
              child: Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("New Group"),
                      GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: SvgPicture.string(AppSvgs.closeCircle,color: AppColors.red,)),
                    ],
                  ),
                 Obx(() =>  Center(
                   child: InkWell(
                     onTap: (){
                       groupController.profileImagePicker();
                     },
                     child: Container(
                       height: 80,
                       width: 80,
                       decoration: BoxDecoration(
                         color: AppColors.text,
                         borderRadius: BorderRadius.circular(10),
                         image: groupController.groupImage.isNotEmpty
                             ? DecorationImage(
                           image: groupController.groupImage.value.startsWith("http")
                               ? NetworkImage(groupController.groupImage.value)
                               : FileImage(File(groupController.groupImage.value))
                           as ImageProvider,
                           fit: BoxFit.cover,
                         )
                           : null,
                       ),
                       child: groupController.groupImage.value.isEmpty
                         ?Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SvgPicture.string(AppSvgs.uploadImage1,color: AppColors.white,),
                           Text("Upload Photo",textAlign: TextAlign.center,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),)
                         ],
                       )
                           : null
                     ),
                   ),
                 ),),
                  AppTextFormField(labelText: "Group Name", controller: groupController.group),
                  Obx(() =>  Align(
                    alignment: AlignmentGeometry.bottomRight,
                    child: GestureDetector(
                      onTap: () async{
                        await groupController.createGroup();
                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColors.selectedColor.value,
                            boxShadow: [
                              BoxShadow(
                                  color: appColors.selectedColor.value.withValues(alpha: 0.4),
                                  offset: const Offset(0, 3),
                                  blurRadius: 10,
                                  spreadRadius: 0
                              ),
                            ]
                        ),
                        child: Center(child: groupController.create.value
                            ?CircularProgressIndicator()
                            :Text("Add",style: Theme.of(context).textTheme.bodyRegular.copyWith(color: AppColors.white),),),
                      ),
                    ),
                  ),),
                ],
              ),
            ),
          ),
        ));
      }, text: "Next", icon: AppSvgs.arrowRightLine),
    );
  }
}
