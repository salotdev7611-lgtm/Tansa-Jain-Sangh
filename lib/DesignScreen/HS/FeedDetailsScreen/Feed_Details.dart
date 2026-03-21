import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Container/Post_Container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Widgets/Dilog/Delete_Dialog.dart';
import '../ContactsDetails/ContactsDetails.dart';
import '../MyProfile/Profile.dart';


class FeedDetails extends StatefulWidget {
  const FeedDetails({super.key, required this.postMsg, required this.profileImg, required this.name, required this.postTime, required this.postId, required this.likeNumber, required this.commentNumber, required this.index, required this.memberId, required this.likeSvg});

  final String profileImg;
  final String name;
  final String postMsg;
  final String postTime;
  final String postId;
  final String? likeNumber;
  final String commentNumber;
  final String memberId;
  final int index;
  final String likeSvg;

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {

  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AppColors appColors = Get.put(AppColors());

  bool bookMark = false;
  bool like = false;
  bool comment = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Feed Detail",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withValues(alpha: 0.08),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(ContactsDetails(
                            name: "",
                            country: '',
                            city: '',
                            connectNo:  "",
                            fullFamilyName: '',
                            profession: "",
                            maritalStatus: '',
                            dateOfBirth: "",
                            permanentLocation: '',
                            residentLocation: '',
                            image: "",
                            id: widget.memberId,
                          ),
                            transition: Transition.fadeIn,duration: Duration(milliseconds: 100),
                          );                        },
                        child: Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.white,
                              backgroundImage: widget.profileImg.isNotEmpty &&
                                  widget.profileImg.startsWith("http")
                                  ? NetworkImage(widget.profileImg)
                                  : const AssetImage("assets/images/no-image.png")
                              as ImageProvider,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.name),
                                Text(widget.postTime),
                              ],
                            ),
                            Spacer(),
                            Obx(() => GestureDetector(
                              onTap: () async {

                                bool isSaved = adminHomeScreenController.saveListData[widget.index];

                                bool success;

                                if (isSaved) {
                                  success = await adminHomeScreenController.profileBookmarkDelete(widget.memberId);
                                } else {
                                  success = await adminHomeScreenController.profileBookmark(widget.memberId);
                                }

                                if (success) {
                                  adminHomeScreenController.saveListData[widget.index] = !isSaved;
                                }

                              },
                              child: widget.memberId == loginScreenController.userId.value
                              ?SizedBox()
                              :SvgPicture.string(
                                adminHomeScreenController.saveListData[widget.index]
                                    ? AppSvgs.bookMarkFilledStared
                                    : AppSvgs.bookMarkOutlineStared,
                                height: 30,
                                width: 30,
                              ),
                            )),
                          ],
                        ),
                      ),
                      Text(widget.postMsg,textAlign: TextAlign.justify,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.grey),),
                      Row(
                        spacing: 5,
                        children: [
                          Obx(() => GestureDetector(
                              onTap: (){
                                adminHomeScreenController.likePost(widget.postId, widget.index);
                              },
                              child: SvgPicture.string(adminHomeScreenController.likeData[widget.index]
                                  ?AppSvgs.likeFilled
                                  : AppSvgs.likeOutline
                                ,height: 30,width: 30,)),),
                          Obx(() => Text(
                            adminHomeScreenController.likeCountData[widget.index].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyBold
                                .copyWith(color: AppColors.text),
                          )),
                          GestureDetector(
                              onTap: (){
                                adminHomeScreenController.editDelete.value = false;
                                adminHomeScreenController.postComments(widget.postId);
                                print("post id ${widget.postId}");
                                adminHomeScreenController.comment.clear();
                                adminHomeScreenController.send.value = false;
                                Get.bottomSheet(
                                  isScrollControlled: true,
                                  Container(
                                    height: 500,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        color: AppColors.white
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                                      child: Column(
                                        spacing: 12,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Spacer(),
                                              SizedBox(
                                                width: 172,
                                                child: Divider(
                                                  color: AppColors.text,
                                                  height: 2,
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: (){
                                                    Get.back();
                                                  },
                                                  child: SvgPicture.string(AppSvgs.closeCircle,color: Colors.red,)),
                                            ],
                                          ),
                                          Obx(() =>   Expanded(
                                            child: ListView.builder(
                                              itemCount: adminHomeScreenController.listOfComments.length,
                                              itemBuilder: (context, index) {
                                                final comments = adminHomeScreenController.listOfComments[index];
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        spacing: 8,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundImage:
                                                            (comments["commented_by"]?["profile_img"] == null ||
                                                                comments["commented_by"]?["profile_img"] == "")
                                                                ? const AssetImage("assets/images/no-image.png")
                                                                : NetworkImage(comments["commented_by"]["profile_img"]),
                                                            backgroundColor: AppColors.white,
                                                          ),

                                                          Expanded(
                                                            child: InkWell(
                                                              onTap: () {
                                                                if(adminHomeScreenController.selectIndex.value == index){
                                                                  adminHomeScreenController.editDelete.value = !adminHomeScreenController.editDelete.value;
                                                                }
                                                                else {
                                                                  adminHomeScreenController.selectIndex.value = index;
                                                                  adminHomeScreenController.editDelete.value = true;
                                                                  adminHomeScreenController.comment.clear();
                                                                  adminHomeScreenController.send.value = false;
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppColors.comment.withValues(alpha: 0.02),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                                  child: Column(

                                                                    spacing: 20,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          comments["commented_by"] == null ?
                                                                          Text("Unauthorized User",
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodyBold
                                                                                .copyWith(color: AppColors.text),
                                                                          )
                                                                              :  Text("${comments["commented_by"]["name"]} ${comments["commented_by"]["surname"]}",
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .bodyBold
                                                                                .copyWith(color: AppColors.text),
                                                                          ),
                                                                          Text(adminHomeScreenController.getTimeDifferenceAsString("${comments["datetime"]}"),
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .body1Regular
                                                                                .copyWith(color: AppColors.grey),
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      Text(
                                                                        comments["comment"] ?? comments["comment"],
                                                                        textAlign: TextAlign.justify,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyRegular
                                                                            .copyWith(color: AppColors.text),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  Obx(() =>
                                                  ((comments["commented_by"]?["id"] ?? "") ==
                                                      adminHomeScreenController.userId.value)
                                                      ? Visibility(
                                                    visible:
                                                    adminHomeScreenController.selectIndex.value == index &&
                                                        adminHomeScreenController.editDelete.value,
                                                    child: Row(
                                                      spacing: 12,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        /// EDIT
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              adminHomeScreenController.comment.text =
                                                                  comments["comment"].toString();
                                                              adminHomeScreenController.send.value = true;
                                                              adminHomeScreenController.commentId.value =
                                                                  comments["id"].toString();
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: AppColors.white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(0xff14453D4D)
                                                                        .withValues(alpha: 0.3),
                                                                    offset: const Offset(0, 0),
                                                                    blurRadius: 10,
                                                                    spreadRadius: 0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Row(
                                                                  spacing: 12,
                                                                  children: [
                                                                    SvgPicture.string(AppSvgs.edit1),
                                                                    Text(
                                                                      "Edit Comment",
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1Regular
                                                                          .copyWith(
                                                                          color: appColors
                                                                              .selectedColor.value),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        /// DELETE
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              adminHomeScreenController.commentId.value =
                                                                  comments["id"].toString();

                                                              Get.dialog(
                                                                Dialog(
                                                                  child: DeleteDialog(
                                                                    title: "Delete Comment",
                                                                    description:
                                                                    "Are you sure you want to delete \n"
                                                                        "${comments["commented_by"]["name"]} "
                                                                        "${comments["commented_by"]["surname"]}?",
                                                                    yesOnTap: () {
                                                                      adminHomeScreenController.deleteComment(
                                                                        adminHomeScreenController
                                                                            .commentId.value,
                                                                        widget.postId,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: AppColors.white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: const Color(0xff14453D4D)
                                                                        .withValues(alpha: 0.3),
                                                                    offset: const Offset(0, 0),
                                                                    blurRadius: 10,
                                                                    spreadRadius: 0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Row(
                                                                  spacing: 12,
                                                                  children: [
                                                                    SvgPicture.string(
                                                                        AppSvgs.deleteOutline),
                                                                    Text(
                                                                      "Delete Comment",
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .body1Regular
                                                                          .copyWith(
                                                                          color: appColors
                                                                              .selectedColor.value),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                      : const SizedBox(),
                                                  ),
                                                  ],
                                                  ),
                                                );
                                              },),
                                          ),),
                                          Row(
                                            spacing: 12,
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundColor: AppColors.white,
                                                backgroundImage: adminHomeScreenController.profile.value.startsWith("http")
                                                    ? NetworkImage(adminHomeScreenController.profile.value)
                                                    : const AssetImage("assets/images/no-image.png")
                                                as ImageProvider,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height : 50,
                                                  decoration: BoxDecoration(
                                                    color : Color(0xff1C252905).withValues(alpha: 0.02),
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: AppColors.grey,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextFormField(
                                                            controller: adminHomeScreenController.comment,
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter text here', // This works with InputBorder.none
                                                              border: InputBorder.none,
                                                              // To ensure no border appears in any state, you can also explicitly set:
                                                              focusedBorder: InputBorder.none,
                                                              enabledBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                              contentPadding: EdgeInsets.all(8), // Optional: adjust padding as needed
                                                            ),
                                                          ),
                                                        ),
                                                        Obx(() =>  GestureDetector(
                                                          onTap : (){
                                                            if(adminHomeScreenController.send.value = true){
                                                              adminHomeScreenController.editComment(adminHomeScreenController.commentId.value, widget.postId);
                                                            }
                                                            else {
                                                              adminHomeScreenController.addComment(widget.postId);
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 98,
                                                            height: 44,
                                                            decoration: BoxDecoration(
                                                              color: appColors.selectedColor.value,
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            child: Center(child: Text(adminHomeScreenController.send.value == true ? "Update" : "send",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.white),),),
                                                          ),
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 20,)
                                        ],
                                      ),
                                    ),
                                  ),);
                              },
                              child: SvgPicture.string(AppSvgs.comment)),
                          Text(widget.commentNumber,style: Theme.of(context).textTheme.bodyBold,),
                          Spacer(),

                          widget.memberId ==
                              adminHomeScreenController.userId.value
                        ?  SizedBox()
                          : GestureDetector(
                              onTap: (){
                                adminHomeScreenController.post.text = widget.postMsg;
                                Get.bottomSheet(
                                    isScrollControlled: true,
                                    Container(
                                      height: 35.h,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        spacing: 12,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            spacing: 12,
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundColor: AppColors.white,
                                                backgroundImage: adminHomeScreenController.profile.value.startsWith("http")
                                                    ? NetworkImage(adminHomeScreenController.profile.value)
                                                    : const AssetImage("assets/images/no-image.png")
                                                as ImageProvider,
                                              ),
                                              Text(adminHomeScreenController.userName.value,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: (){
                                                    Get.back();
                                                  },
                                                  child: SvgPicture.string(AppSvgs.closeCircle,color: Colors.red,)),
                                            ],
                                          ),
                                          TextFormField(
                                            controller: adminHomeScreenController.post,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xffEEEEEE),
                                              hintText: "Write your post or question here",
                                              hintStyle: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.grey),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Color(0xffEEEEEE)),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Color(0xffEEEEEE)),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: AppColors.red),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: AppColors.red),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentGeometry.bottomRight,
                                            child: GestureDetector(
                                              onTap: (){
                                                adminHomeScreenController.editPost(id: widget.postId);
                                              },
                                              child: Container(
                                                height: 42,
                                                width: 161,
                                                decoration: BoxDecoration(
                                                  color: appColors.selectedColor.value,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text("Update",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                              child: SvgPicture.string(AppSvgs.edit1)),

                          widget.memberId ==
                              adminHomeScreenController.userId.value
                           ?SizedBox()
                          : GestureDetector(
                              onTap: (){
                                Get.dialog(Dialog(
                                    child:   DeleteDialog(title: "Delete Post", description: "Are you sure you want to delete ${widget.name} post? ",
                                      yesOnTap: () {adminHomeScreenController.deletePost(id: widget.postId); },)
                                ));
                              },
                              child: SvgPicture.string(AppSvgs.deleteOutline)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Visibility(
              //     visible: comment,
              //     child: ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: 5,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 8 ),
              //       child:  Container(
              //         height: Get.height,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              //             color: AppColors.white
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
              //           child: Column(
              //             spacing: 12,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Expanded(
              //                 child: ListView.builder(
              //                   itemCount: 10,
              //                   itemBuilder: (context, index) {
              //                     return Padding(
              //                       padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             spacing: 8,
              //                             children: [
              //                               CircleAvatar(
              //                                 backgroundImage: AssetImage("assets/images/person.jpg"),
              //                               ),
              //
              //                               Expanded(
              //                                 child: InkWell(
              //                                   onTap: () {
              //                                     if(adminHomeScreenController.selectIndex.value == index){
              //                                       adminHomeScreenController.editDelete.value = !adminHomeScreenController.editDelete.value;
              //                                     }
              //                                     else {
              //                                       adminHomeScreenController.selectIndex.value = index;
              //                                       adminHomeScreenController.editDelete.value = true;
              //                                     }
              //                                   },
              //                                   child: Container(
              //                                     decoration: BoxDecoration(
              //                                       color: AppColors.comment.withValues(alpha: 0.02),
              //                                       borderRadius: BorderRadius.circular(10),
              //                                     ),
              //                                     child: Padding(
              //                                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              //                                       child: Column(
              //
              //                                         spacing: 20,
              //                                         crossAxisAlignment: CrossAxisAlignment.start,
              //                                         children: [
              //                                           Row(
              //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                             children: [
              //                                               Text("It Self Comment",
              //                                                 style: Theme.of(context)
              //                                                     .textTheme
              //                                                     .bodyBold
              //                                                     .copyWith(color: AppColors.text),
              //                                               ),
              //                                               Text("Aug 19, 2021",
              //                                                 style: Theme.of(context)
              //                                                     .textTheme
              //                                                     .body1Regular
              //                                                     .copyWith(color: AppColors.grey),
              //                                               ),
              //                                             ],
              //                                           ),
              //
              //                                           Text(
              //                                             "In mauris porttitor tincidunt mauris massa sit lorem sed scelerisque. Fringilla pharetra vel massa enim sollicitudin cras. At pulvinar eget sociis adipiscing eget donec ultricies nibh tristique.",
              //                                             textAlign: TextAlign.justify,
              //                                             style: Theme.of(context)
              //                                                 .textTheme
              //                                                 .bodyRegular
              //                                                 .copyWith(color: AppColors.text),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           Obx(() =>  Visibility(
              //                             visible: adminHomeScreenController.selectIndex.value == index &&
              //                                 adminHomeScreenController.editDelete.value,
              //                             child:  Row(
              //                               spacing: 12,
              //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                               children: [
              //                                 Expanded(
              //                                   child: GestureDetector(
              //                                     onTap : (){},
              //                                     child: Container(
              //                                       height: 30,
              //                                       decoration: BoxDecoration(
              //                                           borderRadius: BorderRadius.circular(5),
              //                                           color: AppColors.white,
              //                                           boxShadow: [
              //                                             BoxShadow(
              //                                                 color: Color(0xff14453D4D).withValues(alpha: 0.3),
              //                                                 offset: const Offset(0, 0),
              //                                                 blurRadius: 10,
              //                                                 spreadRadius: 0
              //                                             ),
              //                                           ]
              //                                       ),
              //                                       child: Padding(
              //                                         padding: const EdgeInsets.symmetric(horizontal: 8),
              //                                         child: Row(
              //                                           spacing: 12,
              //                                           children: [
              //                                             SvgPicture.string(AppSvgs.edit1),
              //                                             Text("Edit Comment",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),)
              //                                           ],
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 Expanded(
              //                                   child: GestureDetector(
              //                                     onTap: () {
              //                                       Get.dialog(Dialog(
              //                                           child:   DeleteDialog(title: "Delete Comment", description: "Are you sure you want to delete User Name’s comment? ",
              //                                             onTap: () {
              //                                               Get.back();
              //                                               Get.back();
              //                                               Get.back();
              //                                             },)
              //                                       ));
              //
              //                                     },
              //                                     child: Container(
              //                                       height: 30,
              //                                       decoration: BoxDecoration(
              //                                           borderRadius: BorderRadius.circular(5),
              //                                           color: AppColors.white,
              //                                           boxShadow: [
              //                                             BoxShadow(
              //                                                 color: Color(0xff14453D4D).withValues(alpha: 0.3),
              //                                                 offset: const Offset(0, 0),
              //                                                 blurRadius: 10,
              //                                                 spreadRadius: 0
              //                                             ),
              //                                           ]
              //                                       ),
              //                                       child: Padding(
              //                                         padding: const EdgeInsets.symmetric(horizontal: 8),
              //                                         child: Row(
              //                                           spacing: 12,
              //                                           children: [
              //                                             SvgPicture.string(AppSvgs.deleteOutline),
              //                                             Text("Delete Comment",style: Theme.of(context).textTheme.body1Regular.copyWith(color: appColors.selectedColor.value),)
              //                                           ],
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),),)
              //                         ],
              //                       ),
              //                     );
              //                   },),
              //               ),
              //               Row(
              //                 spacing: 12,
              //                 children: [
              //                   CircleAvatar(
              //                     backgroundImage: AssetImage("assets/images/person.jpg"),
              //                   ),
              //                   Expanded(
              //                     child: Container(
              //                       height : 50,
              //                       decoration: BoxDecoration(
              //                         color : Color(0xff1C252905).withValues(alpha: 0.02),
              //                         borderRadius: BorderRadius.circular(30),
              //                         border: Border.all(
              //                           width: 1,
              //                           color: AppColors.grey,
              //                         ),
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.symmetric(horizontal: 12),
              //                         child: Row(
              //                           children: [
              //                             Expanded(
              //                               child: TextFormField(
              //                                 controller: adminHomeScreenController.comment,
              //                                 decoration: InputDecoration(
              //                                   hintText: 'Enter text here', // This works with InputBorder.none
              //                                   border: InputBorder.none,
              //                                   // To ensure no border appears in any state, you can also explicitly set:
              //                                   focusedBorder: InputBorder.none,
              //                                   enabledBorder: InputBorder.none,
              //                                   errorBorder: InputBorder.none,
              //                                   disabledBorder: InputBorder.none,
              //                                   contentPadding: EdgeInsets.all(8), // Optional: adjust padding as needed
              //                                 ),
              //                               ),
              //                             ),
              //                             GestureDetector(
              //                               onTap : (){
              //                                 Get.back();
              //                               },
              //                               child: Container(
              //                                 width: 98,
              //                                 height: 44,
              //                                 decoration: BoxDecoration(
              //                                   color: appColors.selectedColor.value,
              //                                   borderRadius: BorderRadius.circular(100),
              //                                 ),
              //                                 child: Center(child: Text("Send",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.white),),),
              //                               ),
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               SizedBox(height: 20,)
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ))
            ],
          ),
        ),
      )
    );
  }
}
