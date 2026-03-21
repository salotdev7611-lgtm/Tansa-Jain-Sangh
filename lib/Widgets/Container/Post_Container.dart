import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/ManagePost/Manage_Feed_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Dilog/Delete_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Helpers/app_svgs.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({
    super.key,
    required this.profileImg,
    required this.userName,
    required this.time,
    required this.svgComment,
    required this.description,
    required this.likeNumber,
    required this.commentNumber,
    required this.saveSvg,
    required this.index,
    required this.likeSvg,
    required this.onTapCall,
    required this.postId, required this.memberId,
  });

  final String profileImg;
  final String userName;
  final String time;
  final String description;
  final String likeNumber;
  final String svgComment;
  final String commentNumber;
  final String saveSvg;
  final int index;
  final String likeSvg;
  final String postId;
  final String memberId;
  final VoidCallback onTapCall;

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {

  final AppColors appColors = Get.put(AppColors());
  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withValues(alpha: 0.08),
              offset: const Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onTapCall,
              child: Row(
                spacing: 8,
                children: [
                  CircleAvatar(
                    radius: 15,
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
                      Text(
                        widget.userName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyBold
                            .copyWith(color: AppColors.text),
                      ),
                      Text(
                        widget.time,
                        style: Theme.of(context)
                            .textTheme
                            .body2Regular
                            .copyWith(color: AppColors.text),
                      ),
                    ],
                  ),

                  const Spacer(),
                  Obx(() => loginScreenController.userId.value == widget.memberId
                      ? SizedBox()
                  :GestureDetector(
                    onTap: () async {

                      bool isSaved = adminHomeScreenController.saveListData[widget.index];

                      bool success;

                      if (isSaved) {
                        success = await adminHomeScreenController
                            .profileBookmarkDelete(widget.memberId);
                      } else {
                        success = await adminHomeScreenController
                            .profileBookmark(widget.memberId);
                      }

                      if (success) {
                        adminHomeScreenController.saveListData[widget.index] = !isSaved;
                      }

                    },
                    child: SvgPicture.string(
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

            Text(
              widget.description,
              style: Theme.of(context)
                  .textTheme
                  .body1Regular
                  .copyWith(color: AppColors.text),
              textAlign: TextAlign.justify,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),

            Row(
              spacing: 4,
              children: [
                GestureDetector(
                    onTap: (){
                      adminHomeScreenController.likePost(widget.postId, widget.index);
                    },
                    child: SvgPicture.string(widget.likeSvg,height: 30,width: 30,)),
                Obx(() => Text(
                  adminHomeScreenController.likeCountData[widget.index].toString(),
                  style: Theme.of(context)

                      .textTheme
                      .bodyBold
                      .copyWith(color: AppColors.text),
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      //isScrollControlled: true,
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
                                      backgroundImage: NetworkImage(adminHomeScreenController.profile.value),
                                      backgroundColor: AppColors.white,
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
                                                  if(adminHomeScreenController.send.value == true){
                                                    print("object editComment");
                                                    adminHomeScreenController.editComment(adminHomeScreenController.commentId.value, widget.postId);
                                                  }
                                                  else {
                                                    print("object addComment");
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
                    child: Row(
                      spacing: 5,
                      children: [
                        SvgPicture.string(widget.svgComment),
                    Flexible(child: Text(widget.commentNumber, style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text))),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
