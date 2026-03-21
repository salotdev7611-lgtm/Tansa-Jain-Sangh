import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/ManagePost/Manage_Feed_Controller.dart';
import 'package:family_app/DesignScreen/HS/MyProfile/Profile.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars_controller.dart';
import 'package:family_app/Widgets/CustomTabs/app_two_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Widgets/Container/Post_Container.dart';
import '../../../Widgets/Dilog/Delete_Dialog.dart';
import '../FeedDetailsScreen/Feed_Details.dart';

class ManageFeed extends StatefulWidget {
  const ManageFeed({super.key});

  @override
  State<ManageFeed> createState() => _ManageFeedState();
}

class _ManageFeedState extends State<ManageFeed> {

  final AppTwoTabController appTwoTabController = Get.put(AppTwoTabController());
  final ManageFeedController manageFeedController = Get.put(ManageFeedController());
  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manageFeedController.getPost(typeMsg: "");
    appTwoTabController.selectedTwoIndex.value = 0;
    print("appTabBarIconsController.selectedIndex.value${appTwoTabController.selectedTwoIndex.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text("Manage Feed",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          children: [
            Obx(() => SizedBox(
              height: 40,
              child: AppTabIconsBars(
                items: ["Feed", "Notification"],
                icons: [AppSvgs.note, AppSvgs.notification],
                selectedIndex: appTwoTabController.selectedTwoIndex.value, onTap: (index){
                appTwoTabController.selectedTwoIndex.value = index;

                if(index == 0){
                  manageFeedController.getPost(typeMsg: "");
                }
                else if(index == 1){
                  print("notification");
                  manageFeedController.getPost(typeMsg: "admin-notification");
                }

              },
              ),
            ),),
            Obx(() {
              if(manageFeedController.get.value){
                return Center(child: CircularProgressIndicator(),);
              }
              else{
                return Obx(() {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: manageFeedController.listOfPost.length,
                      itemBuilder: (context, index) {
                        final post = manageFeedController.listOfPost[index];
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
                                            manageFeedController.getTimeDifferenceAsString("${post["datetime"]}"),
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

                                          bool isSaved = manageFeedController.saveList[index];

                                          bool success;

                                          if (isSaved) {
                                            success = await manageFeedController
                                                .profileBookmarkDelete(post["posted_by"]["id"]);
                                          } else {
                                            success = await manageFeedController
                                                .profileBookmark(post["posted_by"]["id"]);
                                          }

                                          if (success) {
                                            manageFeedController.saveList[index] = !isSaved;
                                          }

                                        },
                                        child: SvgPicture.string(
                                          manageFeedController.saveList[index]
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
                                  post["content"],
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
                                          manageFeedController.likePost(post["id"], index);
                                        },
                                        child: SvgPicture.string(manageFeedController.like[index]
                                            ? AppSvgs.likeFilled
                                            : AppSvgs.likeOutline,height: 30,width: 30,)),
                                    Obx(() => Text(
                                      manageFeedController.likeCount[index].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyBold
                                          .copyWith(color: AppColors.text),
                                    )),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: (){
                                          //isScrollControlled: true,
                                          manageFeedController.editDelete.value = false;
                                          manageFeedController.postComments(post["id"]);
                                          print("post id ${post["id"]}");
                                          manageFeedController.comment.clear();
                                          manageFeedController.send.value = false;
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
                                                        itemCount: manageFeedController.listOfComments.length,
                                                        itemBuilder: (context, index) {
                                                          final comments = manageFeedController.listOfComments[index];
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
                                                                          if(manageFeedController.selectIndex.value == index){
                                                                            manageFeedController.editDelete.value = !manageFeedController.editDelete.value;
                                                                          }
                                                                          else {
                                                                            manageFeedController.selectIndex.value = index;
                                                                            manageFeedController.editDelete.value = true;
                                                                            manageFeedController.comment.clear();
                                                                            manageFeedController.send.value = false;
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
                                                                                    Text(manageFeedController.getTimeDifferenceAsString("${comments["datetime"]}"),
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
                                                                  manageFeedController.selectIndex.value == index &&
                                                                      manageFeedController.editDelete.value,
                                                                  child: Row(
                                                                    spacing: 12,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      /// EDIT
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            manageFeedController.comment.text =
                                                                                comments["comment"].toString();
                                                                            manageFeedController.send.value = true;
                                                                            manageFeedController.commentId.value =
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
                                                                            manageFeedController.commentId.value =
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
                                                                                    manageFeedController.deleteComment(
                                                                                      manageFeedController
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
                                                                      controller: manageFeedController.comment,
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
                                                                      if(manageFeedController.send.value == true){
                                                                        print("object editComment");
                                                                        manageFeedController.editComment(manageFeedController.commentId.value, post["id"]);
                                                                      }
                                                                      else {
                                                                        print("object addComment");
                                                                        manageFeedController.addComment(post["id"]);
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: 98,
                                                                      height: 44,
                                                                      decoration: BoxDecoration(
                                                                        color: appColors.selectedColor.value,
                                                                        borderRadius: BorderRadius.circular(100),
                                                                      ),
                                                                      child: Center(child: Text(manageFeedController.send.value == true ? "Update" : "send",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.white),),),
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
                },);
              }
            },),
          ],
        )
      ),
      floatingActionButton:
      Obx(() => appTwoTabController.selectedTwoIndex.value == 1
          ? ActiveIconButton(
        onTap: () {
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
                    Container(
                      width: 45,   // required for circle
                      height: 45,  // required for circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appColors.selectedColor.value,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(loginScreenController.profileImg.value),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(loginScreenController.userName.value,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                    Spacer(),
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: SvgPicture.string(AppSvgs.closeCircle,color: Colors.red,)),
                  ],
                ),
                Form(
                  key: manageFeedController.postKey,
                  child:  TextFormField(
                  controller: manageFeedController.post,
                  maxLines: 5,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter post";
                    }
                    return null;
                  },
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
                ),),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: GestureDetector(
                    onTap: (){
                      if(manageFeedController.postKey.currentState!.validate()){
                        manageFeedController.addPost();
                        manageFeedController.post.clear();
                        manageFeedController.getPost(typeMsg: "admin-notification");
                      }
                    },
                    child: Container(
                      height: 42,
                      width: 161,
                      decoration: BoxDecoration(
                        color: appColors.selectedColor.value,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text("Post",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
        },
        text: "Add Notification",
        icon: AppSvgs.add,
      )
          : SizedBox()),
    );
  }
}
