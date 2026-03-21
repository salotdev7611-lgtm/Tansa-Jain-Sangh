import 'package:carousel_slider/carousel_slider.dart';
import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/FeedDetailsScreen/Feed_Details.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/LoginScreen.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/DesignScreen/HS/ManagePost/Manage_Feed.dart';
import 'package:family_app/DesignScreen/HS/MyProfile/Profile.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Cards/admin_event_card.dart';
import 'package:family_app/Widgets/Cards/user_event_card.dart';
import 'package:family_app/Widgets/Container/Post_Container.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars_controller.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../Widgets/Container/Home_Container.dart';
import '../Admin_Setting/Admin_Settings.dart';
import '../Calender/Calender.dart';
import '../ContactsDetails/Contacts.dart';
import '../ContactsDetails/ContactsDetails.dart';
import '../MakePayment/Make_Payment.dart';
import '../ManageEvent/Manage_Event.dart';
import '../Parentage/Parentage.dart';
import '../vidhi/Vidhi.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  final LoginScreenController loginScreenController = Get.put(
      LoginScreenController());

  final AppColors appColors = Get.put(AppColors());

  // dropdown state
  bool showAdminDropdown = false;

  final AdminHomeScreenController adminHomeScreenController = Get.put(
      AdminHomeScreenController());
  final AdminSettingController adminSettingController = Get.put(
      AdminSettingController());
  AddEventController addEventController = Get.put(AddEventController());
  final AppTabBarIconsController appTabBarIconsController = Get.put(
      AppTabBarIconsController());

  @override
  void initState() {
    // adminHomeScreenController.scrollController.addListener(() {
    //   debugPrint("Scroll done");
    //   if (adminHomeScreenController.scrollController.position.pixels ==
    //       adminHomeScreenController.scrollController.position.maxScrollExtent-200){
    //     adminHomeScreenController.loadMorePost();
    //   }
    // },);
    // TODO: implement initState
    super.initState();
    data();
  }

  void data() async {
    print("------------");
    await adminHomeScreenController.getPost(typeMsg: "admin-notification");
    print("get post");
    await addEventController.eventGet(status: "");
  }

  bool isEventLive(String start, String end){
    final now = DateTime.now();
    final startTime = DateTime.parse(start);
    final endTime = DateTime.parse(end);
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      endDrawer: Drawer(
        width: 276, // FIXED WIDTH
        backgroundColor: AppColors.white,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Obx(() =>
                        ListTile(
                          leading: Container(
                            width: 45, // required for circle
                            height: 45, // required for circle
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                image: DecorationImage(image: NetworkImage(
                                    loginScreenController.profileImg.value),
                                    fit: BoxFit.contain)
                            ),
                          ),
                          //CircleAvatar(
                          //                             backgroundColor: AppColors.white,
                          //                             radius: 28,
                          //                             backgroundImage:  NetworkImage(loginScreenController.profileImg.value),
                          //                           ),
                          title: Text(
                            loginScreenController.userName.value,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySemiBold,
                          ),
                        ),),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          showAdminDropdown = false;
                        });
                        Get.back();
                        Get.back();
                        Get.to(Profile(profileImg: loginScreenController
                            .profileImg.value,
                          userName: loginScreenController.userName.value,
                          country: 'dfsd',
                          phoneNumber: loginScreenController.phoneNumber.value,
                          profession: loginScreenController.profession.value,
                          maritalStatus: loginScreenController.maritalStatus
                              .value,
                          dateOfBirth: loginScreenController.dateOfBirth.value,
                          permanentLocation: 'df',
                          residentLocation: loginScreenController.address
                              .value,), transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100));
                        print("login name ,main ${loginScreenController.userName
                            .value}");
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff14453D4D).withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SvgPicture.string(AppSvgs.user,
                                color: appColors.selectedColor.value),
                            const SizedBox(width: 12),
                            Text("Profile",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1Regular
                                    .copyWith(color: AppColors.text)),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(Calender(), transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100));
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff14453D4D).withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SvgPicture.string(AppSvgs.calenderGujarati,
                              color: appColors.selectedColor.value,
                              height: 24,
                              width: 24,),
                            const SizedBox(width: 12),
                            Text(
                              "Calender",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1Regular
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(() =>
                    adminSettingController.payment.value == true
                        ? const SizedBox(height: 20)
                        : SizedBox()),
                    Obx(() {
                      return adminSettingController.payment.value == true ?
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(MakePayment(), transition: Transition.fadeIn,
                              duration: Duration(milliseconds: 100));
                        },
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff14453D4D).withOpacity(
                                    0.3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: SvgPicture.string(AppSvgs.makePayment,
                                    color: appColors.selectedColor.value),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Make Payment",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1Regular
                                    .copyWith(color: AppColors.text),
                              ),
                            ],
                          ),
                        ),
                      )
                          : SizedBox();
                    },),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAdminDropdown = !showAdminDropdown;
                        });
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff14453D4D).withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            SvgPicture.string(AppSvgs.user,
                                color: appColors.selectedColor.value),
                            const SizedBox(width: 12),
                            Text("Admin Action",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1Regular
                                    .copyWith(color: AppColors.text)),
                            const Spacer(),
                            Icon(
                              showAdminDropdown
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: appColors.selectedColor.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ClipRect(
                      child: Container(
                        // duration: const Duration(milliseconds: 300),
                        constraints: showAdminDropdown
                            ? const BoxConstraints()
                            : const BoxConstraints(maxHeight: 0),
                        height: showAdminDropdown ? 270 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff14453D4D).withOpacity(
                                    0.3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 6,
                              children: [
                                SizedBox(height: 5,),
                                SizedBox(
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () {
                                      loginScreenController.addVidhi.value =
                                      true;
                                      setState(() {
                                        showAdminDropdown = false;
                                      });
                                      Get.back();
                                      Get.back();
                                      Get
                                          .to(ManageEvent(),
                                          transition: Transition.fadeIn,
                                          duration: Duration(milliseconds: 100))
                                          ?.then((value) =>
                                          addEventController.eventGet(
                                              status: ""),);
                                    },
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.string(AppSvgs.event,
                                          color: appColors.selectedColor
                                              .value,),
                                        Text("Manage Event", style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1Regular
                                            .copyWith(color: AppColors.text),),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: appColors.selectedColor.value,),
                                SizedBox(
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () {
                                      loginScreenController.addVidhi.value =
                                      true;
                                      setState(() {
                                        showAdminDropdown = false;
                                      });
                                      Get.back();
                                      Get.back();
                                      Get.to(Vidhi(
                                        automaticallyImplyLeading: true,),
                                          transition: Transition.fadeIn,
                                          duration: Duration(
                                              milliseconds: 100));
                                    },
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.string(AppSvgs.vidhi1,
                                          color: appColors.selectedColor
                                              .value,),
                                        Text("Manage Vidhi", style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1Regular
                                            .copyWith(color: AppColors.text),),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: appColors.selectedColor.value,),
                                SizedBox(
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () {
                                      loginScreenController.addVidhi.value =
                                      true;
                                      setState(() {
                                        showAdminDropdown = false;
                                      });
                                      Get.back();
                                      Get.back();
                                      Get.to(Contacts(
                                        automaticallyImplyLeading: true,
                                        isFormConnect: true,),
                                          transition: Transition.fadeIn,
                                          duration: Duration(
                                              milliseconds: 100));
                                    },
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.string(AppSvgs.user,
                                          color: appColors.selectedColor
                                              .value,),
                                        Text("Manage Member", style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1Regular
                                            .copyWith(color: AppColors.text),),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: appColors.selectedColor.value,),
                                SizedBox(
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () {
                                      loginScreenController.addVidhi.value =
                                      true;
                                      setState(() {
                                        showAdminDropdown = false;
                                      });
                                      Get.back();
                                      Get.back();
                                      Get.to(ManageFeed(),
                                          transition: Transition.fadeIn,
                                          duration: Duration(
                                              milliseconds: 100));
                                    },
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.string(AppSvgs.post,
                                          color: appColors.selectedColor
                                              .value,),
                                        Text("Manage Post", style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1Regular
                                            .copyWith(color: AppColors.text),),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(color: appColors.selectedColor.value,),
                                SizedBox(
                                  height: 26,
                                  child: GestureDetector(
                                    onTap: () {
                                      loginScreenController.addVidhi.value =
                                      true;
                                      setState(() {
                                        showAdminDropdown = false;
                                      });
                                      Get.back();
                                      Get.back();
                                      Get.to(AdminSettings(),
                                          transition: Transition.fadeIn,
                                          duration: Duration(
                                              milliseconds: 100));
                                    },
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.string(AppSvgs.setting,
                                          color: appColors.selectedColor
                                              .value,),
                                        Text("Admin Setting", style: Theme
                                            .of(context)
                                            .textTheme
                                            .body1Regular
                                            .copyWith(color: AppColors.text),),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // const SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: () {
                    //
                    //   },
                    //   child: Container(
                    //     height: 42,
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.white,
                    //       borderRadius: BorderRadius.circular(5),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: const Color(0xff14453D4D).withOpacity(0.3),
                    //           blurRadius: 5,
                    //         ),
                    //       ],
                    //     ),
                    //
                    //     child: Row(
                    //       children: [
                    //         SvgPicture.string(AppSvgs.note, color: appColors.selectedColor.value),
                    //         const SizedBox(width: 12),
                    //         Text("Terms & Conditions",
                    //             style: Theme.of(context).textTheme.body1Regular
                    //                 .copyWith(color: AppColors.text)),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: () {
                    //
                    //   },
                    //   child: Container(
                    //     height: 42,
                    //     padding: const EdgeInsets.symmetric(horizontal: 10),
                    //     decoration: BoxDecoration(
                    //       color: AppColors.white,
                    //       borderRadius: BorderRadius.circular(5),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: const Color(0xff14453D4D).withOpacity(0.3),
                    //           blurRadius: 5,
                    //         ),
                    //       ],
                    //     ),
                    //
                    //     child: Row(
                    //       children: [
                    //         SvgPicture.string(AppSvgs.note, color: appColors.selectedColor.value),
                    //         const SizedBox(width: 12),
                    //         Text("Privacy & Policy",
                    //             style: Theme.of(context).textTheme.body1Regular
                    //                 .copyWith(color: AppColors.text)),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showAdminDropdown = false;
                        });
                        Get.back();
                        Get.back();
                        loginScreenController.logOut();
                        // Get.to(LoginScreen(),transition: Transition.noTransition,duration: Duration(milliseconds: 0));
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff14453D4D).withOpacity(0.3),
                              blurRadius: 5,
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            SvgPicture.string(AppSvgs.powerOff,
                                color: appColors.selectedColor.value),
                            const SizedBox(width: 12),
                            Text("Logout",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1Regular
                                    .copyWith(color: AppColors.text)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 120),
              child: Center(child: Column(
                children: [
                  Text("Powered By"),
                  Image.asset("assets/images/img.png", height: 30, width: 100,)
                ],
              )),
            )
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(ApiUrl.appLogo, height: 35, fit: BoxFit.contain,),
            const Spacer(),
            Text(
              ApiUrl.appName,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyRegular
                  .copyWith(color: AppColors.text),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: adminHomeScreenController
            .scrollController,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (addEventController.get.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (addEventController.listOfEvent.isEmpty) {
                  return GifView.asset("assets/images/no-event.gif",);
                }
                else {
                  return CarouselSlider.builder(
                    itemCount: addEventController.listOfEvent.length,
                    itemBuilder: (context, index, realIndex) {
                      final event = addEventController.listOfEvent[index];
                      return UserEventCard(
                        date: DateFormat("MMM dd").format(
                            DateTime.parse(event["start_datetime"])),
                        eventName: event["title"],
                        time: "Friday, 5:00PM to 7:30PM",
                        location: event["location"],
                        isLive: isEventLive(
                          event["start_datetime"],
                          event["end_datetime"],
                        ),
                        image: event['img'] ??
                            "assets/images/no-image.png",
                        liveLinkUrl: event["live_url"],
                      );
                    },
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(
                          milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                }
              }
              ),
              Obx(() {
                return Column(
                  spacing: 18,
                  children: [
                    SizedBox(
                      height: 40,
                      child: AppTabIconsBars(
                        items: ["Notification", "Favorite", "Feed"],
                        icons: [
                          AppSvgs.notification,
                          AppSvgs.bookMarkOutlineStared,
                          AppSvgs.note
                        ],
                        selectedIndex: adminHomeScreenController.selectIndexPost.value,
                        onTap: (index) {
                          adminHomeScreenController.selectIndexPost.value = index;
                          if (index == 0) {
                            adminHomeScreenController.getPost(
                                typeMsg: "admin-notification");
                          }
                          else if (index == 1) {
                            adminHomeScreenController.getPost(
                                typeMsg: "bookmarked-profile");
                          }
                          else if (index == 2) {
                            adminHomeScreenController.getPost(typeMsg: "");
                          }
                        },
                      ),
                    ),

                    Obx(() {
                      if (adminHomeScreenController.get.value) {
                        return CircularProgressIndicator();
                      }
                      else if (adminHomeScreenController.listOfPost.isEmpty) {
                        return Text("No Post Found");
                      }
                      else {

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (adminHomeScreenController.postModel.value.data?.length ?? 0) + 1,
                          itemBuilder: (context, index) {
                            if (index == adminHomeScreenController.postModel.value.data?.length) {
                              return Obx(() =>
                              adminHomeScreenController.isLoadingMore.value
                                  ? Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : SizedBox());
                            }
                            final post = adminHomeScreenController.postModel.value.data?[index];
                            return Obx(() =>
                                InkWell(
                                  onTap: () {
                                    Get.to(FeedDetails(
                                      postMsg: post?.content ?? "",
                                      memberId: post?.postedBy?.id ?? "",
                                      profileImg: post?.postedBy?.profileImg ?? "assets/images/no-image.png",
                                      name: '${post?.postedBy?.name} ${post?.postedBy?.surname}',
                                      // name: '${post["posted_by"]["name"]} ${post["posted_by"]["surname"]}',
                                      postTime: adminHomeScreenController
                                          .getTimeDifferenceAsString(
                                          "${post?.datetime}"),
                                      postId: post?.id ?? "",
                                      likeNumber: post?.likes,
                                      commentNumber: post?.comments ?? "",
                                      likeSvg: adminHomeScreenController
                                          .likeData[index]
                                          ? AppSvgs.likeFilled
                                          : AppSvgs.likeOutline,
                                      index: index,
                                    ), transition: Transition.fadeIn,
                                        duration: Duration(milliseconds: 100));
                                  },
                                  child: PostContainer(
                                    postId: "${post?.id}",
                                    profileImg: post?.postedBy?.profileImg ??
                                        "assets/images/no-image.png",
                                    memberId: post?.postedBy?.id ?? "",
                                    userName: "${post?.postedBy?.name} ${post?.postedBy?.surname}",
                                    time: adminHomeScreenController
                                        .getTimeDifferenceAsString(
                                        "${post?.datetime}"),
                                    svgComment: AppSvgs.comment,
                                    description: post?.content ?? "",
                                    likeNumber: post?.likes ?? "",
                                    commentNumber: post?.comments ?? "",
                                    saveSvg: adminHomeScreenController
                                        .saveListData[index]
                                        ? AppSvgs.bookMarkFilledStared
                                        : AppSvgs.bookMarkOutlineStared,
                                    index: index,
                                    likeSvg: adminHomeScreenController
                                        .likeData[index]
                                        ? AppSvgs.likeFilled
                                        : AppSvgs.likeOutline,
                                    onTapCall: () {
                                      Get.to(ContactsDetails(
                                        name: "${post?.postedBy?.name ?? ""} ${post?.postedBy?.surname ?? ""}",
                                        country: '',
                                        city: '',
                                        connectNo: post?.postedBy?.mobileNo ?? "",
                                        fullFamilyName: '',
                                        profession: post?.postedBy?.profession ?? "",
                                        maritalStatus: '',
                                        dateOfBirth: post?.postedBy?.dob?.toString() ?? "",
                                        permanentLocation: '',
                                        residentLocation: '',
                                        image: post?.postedBy?.profileImg ??
                                            "assets/images/no-image.png",
                                        id: post?.postedBy?.id ?? "",
                                      ),
                                        transition: Transition.fadeIn,
                                        duration: Duration(milliseconds: 100),
                                      );
                                      // Get.to(Profile(
                                      //   profileImg: post["posted_by"]?["profile_img"] ?? "assets/images/no-image.png",
                                      //   userName: "${post["posted_by"]?["name"] ?? ""} ${post["posted_by"]?["surname"] ?? ""}",
                                      //   country: 'cccccc',
                                      //   phoneNumber: post["posted_by"]?["mobile_no"] ?? "",
                                      //   profession: post["posted_by"]?["profession"] ?? "",
                                      //   maritalStatus: 'mmmmm',
                                      //   dateOfBirth: post["posted_by"]?["dob"] ?? "",
                                      //   permanentLocation: "aaaaaa",
                                      //   residentLocation:  "safkjhskdf",
                                      // ),duration: Duration(milliseconds: 100),transition: Transition.fadeIn);
                                    },
                                  ),
                                ),
                            );
                          },
                        );
                      }
                    },),
                  ],
                );
              },),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          onPressed: () {
            adminHomeScreenController.post.clear();
            Get.bottomSheet(
                isScrollControlled: true,
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          Container(
                            width: 45, // required for circle
                            height: 45, // required for circle
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: appColors.selectedColor.value,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    loginScreenController.profileImg.value),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Obx(() =>
                              Text(loginScreenController.userName.value,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyBold
                                    .copyWith(color: AppColors.text),),),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.string(AppSvgs.closeCircle,
                                color: Colors.red,)),
                        ],
                      ),
                      Form(
                        key: adminHomeScreenController.postKey,
                        child: TextFormField(
                          controller: adminHomeScreenController.post,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffEEEEEE),
                            hintText: "Write your post or question here",
                            hintStyle: Theme
                                .of(context)
                                .textTheme
                                .bodySemiBold
                                .copyWith(color: AppColors.grey),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Post Message";
                            }
                            return null;
                          },
                        ),),
                      Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            if (adminHomeScreenController.postKey.currentState!.validate()) {
                              adminHomeScreenController.addPost();
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
                              child: Text("Post", style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1Regular
                                  .copyWith(color: AppColors.white),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
          backgroundColor: appColors.selectedColor.value,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          icon: SvgPicture.string(AppSvgs.add, color: Colors.white),
          label: Text(
            "Create Post",
            style: Theme
                .of(context)
                .textTheme
                .bodyRegular
                .copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
