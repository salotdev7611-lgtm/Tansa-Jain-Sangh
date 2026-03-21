import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:family_app/DesignScreen/HS/Calender/Calender.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/MakePayment/Make_Payment.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/Widgets/Cards/user_event_card.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Helpers/api_url.dart';
import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../../../Widgets/Container/Post_Container.dart';
import '../ContactsDetails/ContactsDetails.dart';
import '../FeedDetailsScreen/Feed_Details.dart';
import '../LoginScreen/LoginScreen.dart';
import '../MyProfile/Profile.dart';


class HomeScreenBottomDrawer extends StatefulWidget {
  const HomeScreenBottomDrawer({super.key});

  @override
  State<HomeScreenBottomDrawer> createState() => _HomeScreenBottomDrawerState();
}

class _HomeScreenBottomDrawerState extends State<HomeScreenBottomDrawer>{
  final AppColors appColors = Get.put(AppColors());
  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  final AppTabBarIconsController appTabBarIconsController = Get.put(AppTabBarIconsController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AddEventController addEventController = Get.put(AddEventController());
  @override
  void initState() {
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
  bool isEventLive(String start, String end) {
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
            width: 276 ,
            backgroundColor: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Obx(() =>   ListTile(
                    leading: Container(
                      width: 45,   // required for circle
                      height: 45,  // required for circle
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          image: DecorationImage(image: NetworkImage(loginScreenController.profileImg.value),fit: BoxFit.contain)
                      ),
                    ),
                    //CircleAvatar(
                    //                             backgroundColor: AppColors.white,
                    //                             radius: 28,
                    //                             backgroundImage:  NetworkImage(loginScreenController.profileImg.value),
                    //                           ),
                    title: Text(
                      loginScreenController.userName.value,
                      style: Theme.of(context).textTheme.bodySemiBold,
                    ),
                  ),),

                  SizedBox(height: 30,),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(Calender(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
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
                              color: appColors.selectedColor.value,height: 24,width: 24,),
                          const SizedBox(width: 12),
                          Text(
                            "Calender",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  InkWell(
                    onTap: () {

                      Get.back();
                      Get.to(Profile(profileImg: '', userName: '', country: '', phoneNumber: '', profession: '', maritalStatus: '', dateOfBirth: '', permanentLocation: '', residentLocation: '',),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
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
                          Text(
                            "Profile",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(MakePayment(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
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
                          SvgPicture.string(AppSvgs.makePayment,
                              color: appColors.selectedColor.value,height: 20,width: 20,),
                          const SizedBox(width: 12),
                          Text(
                            "Make Payment",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  InkWell(
                    onTap: () {
                      Get.back();
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
                          SvgPicture.string(AppSvgs.note,
                              color: appColors.selectedColor.value),
                          const SizedBox(width: 12),
                          Text(
                            "Terms & Conditions",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  InkWell(
                    onTap: () {
                      Get.back();
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
                          SvgPicture.string(AppSvgs.note,
                              color: appColors.selectedColor.value),
                          const SizedBox(width: 12),
                          Text(
                            "Privacy & Policy",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),

                  InkWell(
                    onTap: () {
                     loginScreenController.logOut();
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
                          Text(
                            "Logout",
                            style: Theme.of(context)
                                .textTheme
                                .body1Regular
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.white,
            title: Row(
              children: [
                Image.asset(ApiUrl.appLogo, height: 35,fit: BoxFit.contain,),
                const Spacer(),
                Text(
                  ApiUrl.appName,
                  style: Theme.of(context).textTheme.bodyRegular
                      .copyWith(color: AppColors.text),
                ),
                const Spacer(),
              ],
            ),
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if(addEventController.get.value){
                      return Center(child: CircularProgressIndicator());
                    }
                    if(addEventController.listOfEvent.isEmpty){
                      return Center(child: Text("No Event Found"));
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
                            items: ["Notification" , "Favorite" , "Feed"],
                            icons: [AppSvgs.notification, AppSvgs.bookMarkOutlineStared, AppSvgs.note],
                            selectedIndex: appTabBarIconsController.selectedIndex.value,
                            onTap: (index){
                              appTabBarIconsController.selectedIndex.value = index;
                              if(index == 0){
                                adminHomeScreenController.getPost(typeMsg: "admin-notification");
                              }
                              else if(index == 1){
                                adminHomeScreenController.getPost(typeMsg: "bookmarked-profile");
                              }
                              else if (index == 2){
                                adminHomeScreenController.getPost(typeMsg: "");
                              }
                            },
                          ),
                        ),

                        Obx(() {
                          if(adminHomeScreenController.get.value){
                            return CircularProgressIndicator();
                          }
                          else if(adminHomeScreenController.listOfPost.isEmpty){
                            return Text("No Post Found");
                          }
                          else{
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: adminHomeScreenController.listOfPost.length,
                              itemBuilder: (context, index) {
                                final post = adminHomeScreenController.listOfPost[index];
                                return Obx(() => InkWell(
                                  onTap: (){
                                    Get.to(FeedDetails(
                                      postMsg: post["content"],
                                      memberId: post["posted_by"]["id"] ?? "",
                                      profileImg: post["posted_by"]["profile_img"] ?? "assets/images/no-image.png" ,
                                      name: '${post["posted_by"]["name"]} ${post["posted_by"]["surname"]}',
                                      postTime: adminHomeScreenController.getTimeDifferenceAsString("${post["datetime"]}"),
                                      postId: post["id"],
                                      likeNumber: post["likes"],
                                      commentNumber: post["comments"],
                                      likeSvg: adminHomeScreenController.likeData[index]
                                          ? AppSvgs.likeFilled
                                          : AppSvgs.likeOutline,
                                      index: index,
                                    ),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                                  },
                                  child: PostContainer(
                                    postId: "${post["id"]}",
                                    profileImg: post["posted_by"]["profile_img"] ?? "assets/images/no-image.png",
                                    memberId: post["posted_by"]["id"] ?? "",
                                    userName: "${post["posted_by"]["name"]} ${post["posted_by"]["surname"]}",
                                    time: adminHomeScreenController.getTimeDifferenceAsString("${post["datetime"]}"),
                                    svgComment: AppSvgs.comment,
                                    description: post["content"],
                                    likeNumber: post["likes"],
                                    commentNumber: post["comments"],
                                    saveSvg: adminHomeScreenController.saveListData[index]
                                        ? AppSvgs.bookMarkFilledStared
                                        : AppSvgs.bookMarkOutlineStared,
                                    index: index,
                                    likeSvg: adminHomeScreenController.likeData[index]
                                        ? AppSvgs.likeFilled
                                        : AppSvgs.likeOutline,
                                    onTapCall: () {
                                      Get.to(ContactsDetails(
                                        name: "${post["posted_by"]?["name"] ?? ""} ${post["posted_by"]?["surname"] ?? ""}",
                                        country: '',
                                        city: '',
                                        connectNo: post["posted_by"]?["mobile_no"] ?? "",
                                        fullFamilyName: '',
                                        profession: post["posted_by"]?["profession"] ?? "",
                                        maritalStatus: '',
                                        dateOfBirth: post["posted_by"]?["dob"]??"",
                                        permanentLocation: '',
                                        residentLocation: '',
                                        image: post["posted_by"]?["profile_img"] ?? "assets/images/no-image.png",
                                        id: post["posted_by"]["id"],
                                      ),
                                        transition: Transition.fadeIn,duration: Duration(milliseconds: 100),
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
                                    image: AssetImage("assets/images/person.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("John Doe",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
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
                                Get.back();
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
              backgroundColor: appColors.selectedColor.value,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
              ),
              icon: SvgPicture.string(AppSvgs.add, color: Colors.white),
              label: Text(
                "Create Post",
                style: Theme.of(context)
                    .textTheme
                    .bodyRegular
                    .copyWith(color: AppColors.white),
              ),
            ),
          ),
        );
  }

}
