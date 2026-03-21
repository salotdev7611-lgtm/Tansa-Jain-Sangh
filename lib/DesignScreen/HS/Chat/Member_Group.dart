import 'package:family_app/DesignScreen/HS/Chat/Group_Controller.dart';
import 'package:family_app/DesignScreen/HS/Chat/Member_Group_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Widgets/Checkboxes/app_check_box.dart';

class MemberGroup extends StatefulWidget {
  const MemberGroup({super.key, required this.groupProfileImg, required this.groupName, required this.groupId, required this.createdBy});

  final String groupProfileImg;
  final String groupName;
  final String groupId;
  final String createdBy;

  @override
  State<MemberGroup> createState() => _MemberGroupState();
}

class _MemberGroupState extends State<MemberGroup> {

  final AppColors appColors = Get.put(AppColors());
  final MemberGroupController memberGroupController = Get.put(MemberGroupController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("LOGGIN USER ID : ${loginScreenController.userId.value}");
    memberGroupController.getGroupMember(widget.groupId);
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
        title: Text("Group Member",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withValues(alpha: 0.09),
                          offset: const Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    image: DecorationImage(image: NetworkImage(widget.groupProfileImg),
                    fit: BoxFit.contain
                    )
                  ),
                ),
              ),
              // Center(
              //   child: CircleAvatar(
              //     radius: 60,
              //     backgroundColor: AppColors.white,
              //     backgroundImage: NetworkImage(widget.groupProfileImg),
              //   ),
              // ),
              Center(child: Text(widget.groupName,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),)),
              SizedBox(height: 14,),
              loginScreenController.userId.value == widget.createdBy
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      memberGroupController.deleteGroup(widget.groupId);
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: appColors.selectedColor.value,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: appColors.selectedColor.value.withValues(alpha: 0.3),
                              offset: const Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 0
                          ),
                        ],
                      ),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.string(AppSvgs.deleteFilled,colorFilter:ColorFilter.mode(appColors.selectedColor.value, BlendMode.srcATop)),
                          Text("Delete Group",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await memberGroupController.getMember();
                      await memberGroupController.getGroupMember(widget.groupId);

                      memberGroupController.filterMembers();
                      Get.bottomSheet(
                          Container(
                              height: 500,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 8,),
                                    GestureDetector(
                                      onTap: (){
                                        Get.back();
                                      },
                                      child: Align(
                                        alignment: AlignmentGeometry.topRight,
                                        child: SvgPicture.string(AppSvgs.closeCircle,colorFilter:ColorFilter.mode(AppColors.red, BlendMode.srcATop)),
                                      ),
                                    ),
                                    Expanded(
                                        child: Obx(() {
                                          if(memberGroupController.get.value){
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          else if(memberGroupController.listOfFilterMember.isEmpty){
                                            return Center(child: Text("No Member Found",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),));
                                          }
                                          else {
                                            return ListView.builder(
                                              itemCount: memberGroupController.listOfFilterMember.length,
                                              itemBuilder: (context, index) {
                                                final member =memberGroupController.listOfFilterMember[index];
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
                                                        Text("${member["name"]} ${member["surname"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                                                        Spacer(),
                                                        Obx(() => Radio<String>(
                                                          value: member["id"].toString(),
                                                          groupValue: memberGroupController.memberId.value,
                                                          onChanged: (val) {
                                                            memberGroupController.addButton.value = true;
                                                            memberGroupController.memberId.value = val!;
                                                          },
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },);
                                          }
                                        },)
                                    ),

                                    Obx(() => Visibility(
                                      visible: memberGroupController.addButton.value,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await memberGroupController.addMember(
                                                groupId: widget.groupId,
                                                memberId: memberGroupController.memberId.value,
                                              );

                                              await memberGroupController.getGroupMember(widget.groupId);
                                              memberGroupController.filterMembers();   // refresh filter
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: appColors.selectedColor.value,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(child: Text("Add",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),)
                                  ],
                                ),
                              )
                          ));
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: appColors.selectedColor.value,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: appColors.selectedColor.value.withValues(alpha: 0.3),
                              offset: const Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 0
                          ),
                        ],
                      ),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.string(AppSvgs.add,colorFilter:ColorFilter.mode(appColors.selectedColor.value, BlendMode.srcATop)),
                          Text("Add Member",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : SizedBox(),
              Obx(() {
                return ListView.builder(
                  itemCount: memberGroupController.listOfGroupMember.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final member = memberGroupController.listOfGroupMember[index];

                    print("member id ${member["id"]}");
                    print("created by id ${widget.createdBy}");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsetsGeometry.all(8),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: appColors.selectedColor.value
                          ),
                        ),
                        child: Row(
                          spacing: 12,
                          children: [


                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                image: member["profile_img"] != null &&
                                    member["profile_img"].toString().isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(member["profile_img"]),
                                  fit: BoxFit.contain, // ✅ your boxFit here
                                )
                                    : null,
                              ),
                              child: member["profile_img"] == null ||
                                  member["profile_img"].toString().isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),

                            Text("${member["name"]} ${member["surname"]}",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                            Spacer(),
                            member["id"] == widget.createdBy
                                ?  SizedBox()
                                :  SizedBox(),

                          member["id"] == widget.createdBy
                          ? Text("Admin",style: Theme.of(context).textTheme.body2Bold.copyWith(color: appColors.selectedColor.value),)
                              : loginScreenController.userId.value == widget.createdBy ? GestureDetector(
                            onTap: () {
                              memberGroupController.deleteMember(
                                widget.groupId,
                                member["id"].toString(),
                              );
                            },
                            child: SvgPicture.string(AppSvgs.deleteFilled),
                          ) : SizedBox()

                          ],
                        ),
                      ),
                    );
                  },);
              },)
            ],
          ),
        ),
      ),
    );
  }
}
