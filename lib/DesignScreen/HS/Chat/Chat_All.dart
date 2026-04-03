import 'package:family_app/DesignScreen/HS/Chat/Chat_All_Controller.dart';
import 'package:family_app/DesignScreen/HS/Chat/Chat_Screen.dart';
import 'package:family_app/DesignScreen/HS/Chat/Create_Group.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bar_controller.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bars.dart';
import 'package:family_app/Widgets/TextFormFields/app_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatAll extends StatefulWidget {
  const ChatAll({super.key});

  @override
  State<ChatAll> createState() => _ChatAllState();
}

class _ChatAllState extends State<ChatAll> {

  final AppTabBarController appTabBarController = Get.put(AppTabBarController());
  final ChatAllController chatAllController = Get.put(ChatAllController());
  final AppColors appColors = Get.put(AppColors());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatAllController.getChatData("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Chat",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        actions: [
          Obx(() => appTabBarController.selectedIndex.value == 2 ? Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
                onTap: (){
                  Get.to(CreateGroup(),transition: Transition.noTransition,duration: Duration(milliseconds: 100));
                },
                child: Text("Create Group",style: Theme.of(context).textTheme.body1Bold.copyWith(color: appColors.selectedColor.value),)),
          ) : SizedBox(),)
          // SizedBox(width: 16,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: AppSearchbar(controller: chatAllController.search),
            ),

            SizedBox(height: 20),

            Obx(() => Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: AppTabBars(
                      items: ["All", "Chat", "Group"],
                      selectedIndex: appTabBarController.selectedIndex.value,
                      onTap: (int index) {
                        appTabBarController.selectedIndex.value = index;

                        if (index == 0) {
                          chatAllController.getChatData("");
                        } else if (index == 1) {
                          chatAllController.getChatData("personal");
                        } else {
                          chatAllController.getChatData("group");
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: chatAllController.listOfChatUser.length,
                  itemBuilder: (context, index) {
                    final chat = chatAllController.listOfChatUser[index];
                    return InkWell(
                      onTap: () {
                        final bool isGroupChat = chat["group_id"] != null;

                        Get.to(
                          ChatScreen(
                            name: isGroupChat
                                ? chat["group_id"]["name"]
                                : "${chat["member_id"]["name"]} ${chat["member_id"]["surname"]}",

                            profileImg: isGroupChat
                                ? chat["group_id"]["profile_icon"]
                                : chat["member_id"]["profile_img"],

                            memberId: isGroupChat
                                ? ""
                                : chat["member_id"]["id"],

                            groupId: isGroupChat
                                ? chat["group_id"]["id"]
                                : "",

                            createdBy: isGroupChat
                                ? chat["group_id"]["created_by"]
                                : "",
                          ),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        height: 81,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: appColors.selectedColor.value.withValues(alpha: 0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [

                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(chat["group_id"]?["profile_icon"] ?? chat["member_id"]?["profile_img"] ?? ""),
                                      fit: BoxFit.contain
                                  ),
                                ),
                              ),

                              // CircleAvatar(
                              //   radius: 25,
                              //   backgroundImage: NetworkImage(chat["group_id"]?["profile_icon"] ?? chat["member_id"]?["profile_img"] ?? ""),
                              // ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat["group_id"]?["name"] ?? "${chat["member_id"]?["name"]} ${chat["member_id"]?["surname"]}" ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyBold
                                          .copyWith(color: AppColors.text),
                                    ),
                                    // SizedBox(height: ),
                                    Text(
                                      chat["last_message"] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1Regular
                                          .copyWith(color: AppColors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 12),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  chat["last_message_time"] == null ?SizedBox():
                                  Text(chatAllController.getTimeDifferenceAsString(chat["last_message_time"]),
                                      style: Theme.of(context).textTheme.bodyRegular),
                                  SizedBox(height: 8),
                                  chat["unread_msg"] == "0"
                                      ? SizedBox()
                                      : Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      color: appColors.selectedColor.value,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        chat["unread_msg"] ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .body4Bold
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
                ],),
            ),)
          ],
        ),
      ),
    );
  }
}
