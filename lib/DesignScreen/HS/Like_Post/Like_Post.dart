import 'package:family_app/DesignScreen/HS/Like_Post/Like_Post_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/Container/Post_Container.dart';
import '../../../Widgets/Dilog/Delete_Dialog.dart';
import '../ContactsDetails/ContactsDetails.dart';
import '../FeedDetailsScreen/Feed_Details.dart';
import '../HomeScreen/Admin_Home_Screen_controller.dart';
import '../MyProfile/Profile.dart';

class LikePost extends StatefulWidget {
  const LikePost({super.key});

  @override
  State<LikePost> createState() => _LikePostState();
}

class _LikePostState extends State<LikePost> {

  final LikePostController likePostController = Get.put(LikePostController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AppColors appColors = Get.put(AppColors());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likePostController.getLikePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title:  Text("Like Post",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: ListView.builder(
            itemCount: likePostController.listOfLikePost.length,
            itemBuilder: (context, index) {
              final post = likePostController.listOfLikePost[index];
              return Obx(() =>  Padding(
                padding: const EdgeInsets.only(bottom: 18),
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
                        onTap: (){},
                        child: Row(
                          spacing: 8,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.white,
                              backgroundImage: post["posted_by"]["profile_img"].toString().isEmpty || post["posted_by"]["profile_img"] == null
                                  ? AssetImage("assets/images/no-image.png")
                                  : NetworkImage(post["posted_by"]["profile_img"] ?? ""),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${post["posted_by"]["name"]} ${post["posted_by"]["surname"]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyBold
                                      .copyWith(color: AppColors.text),
                                ),
                                Text(
                                  likePostController.getTimeDifferenceAsString("${post["datetime"]}"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2Regular
                                      .copyWith(color: AppColors.text),
                                ),
                              ],
                            ),

                            const Spacer(),
                            Obx(() => loginScreenController.userId.value == post["posted_by"]["id"]
                                ? SizedBox()
                                :GestureDetector(
                              onTap: () async {

                                bool isSaved = likePostController.saveList[index];

                                bool success;

                                if (isSaved) {
                                  success = await likePostController
                                      .profileBookmarkDelete(post["posted_by"]["id"]);
                                } else {
                                  success = await likePostController
                                      .profileBookmark(post["posted_by"]["id"]);
                                }

                                if (success) {
                                  likePostController.saveList[index] = !isSaved;
                                }

                              },
                              child: SvgPicture.string(
                                likePostController.saveList[index]
                                    ? AppSvgs.bookMarkFilledStared
                                    : AppSvgs.bookMarkOutlineStared,
                                height: 30,
                                width: 30,
                              ),
                            )),

                          ],
                        ),
                      ),

                      Text(post["content"],
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
                                likePostController.likePost(post["id"], index);
                              },
                              child: SvgPicture.string(likePostController.like[index]
                                  ? AppSvgs.likeFilled
                                  : AppSvgs.likeOutline,height: 30,width: 30,)),
                          Obx(() => Text(
                            likePostController.likeCount[index].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyBold
                                .copyWith(color: AppColors.text),
                          )),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                //isScrollControlled: true,
                                likePostController.editDelete.value = false;
                                likePostController.postComments(post["id"]);
                                print("post id ${post["id"]}");
                                likePostController.comment.clear();
                                likePostController.send.value = false;
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
                                              itemCount: likePostController.listOfComments.length,
                                              itemBuilder: (context, index) {
                                                final comments = likePostController.listOfComments[index];
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
                                                                if(likePostController.selectIndex.value == index){
                                                                  likePostController.editDelete.value = !likePostController.editDelete.value;
                                                                }
                                                                else {
                                                                  likePostController.selectIndex.value = index;
                                                                  likePostController.editDelete.value = true;
                                                                  likePostController.comment.clear();
                                                                  likePostController.send.value = false;
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
                                                                          Text(likePostController.getTimeDifferenceAsString("${comments["datetime"]}"),
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
                                                          loginScreenController.userId.value)
                                                          ? Visibility(
                                                        visible:
                                                        likePostController.selectIndex.value == index &&
                                                            likePostController.editDelete.value,
                                                        child: Row(
                                                          spacing: 12,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            /// EDIT
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  likePostController.comment.text =
                                                                      comments["comment"].toString();
                                                                  likePostController.send.value = true;
                                                                  likePostController.commentId.value =
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
                                                                  likePostController.commentId.value =
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
                                                                          likePostController.deleteComment(
                                                                            likePostController
                                                                                .commentId.value,
                                                                            post["id"],
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
                                                backgroundImage: NetworkImage(loginScreenController.profileImg.value),
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
                                                            controller: likePostController.comment,
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
                                                            if(likePostController.send.value == true){
                                                              print("object editComment");
                                                              likePostController.editComment(likePostController.commentId.value, post["id"]);
                                                            }
                                                            else {
                                                              print("object addComment");
                                                              likePostController.addComment(post["id"]);
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 98,
                                                            height: 44,
                                                            decoration: BoxDecoration(
                                                              color: appColors.selectedColor.value,
                                                              borderRadius: BorderRadius.circular(100),
                                                            ),
                                                            child: Center(child: Text(likePostController.send.value == true ? "Update" : "send",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.white),),),
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
                                    SvgPicture.string(AppSvgs.comment),
                                    Flexible(child: Text(post["comments"], style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text))),
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),);
            },
          ),
        );
      },)
    );
  }
}
