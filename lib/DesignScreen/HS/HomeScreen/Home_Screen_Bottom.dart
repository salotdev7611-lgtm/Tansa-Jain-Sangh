import 'package:carousel_slider/carousel_slider.dart';
import 'package:family_app/DesignScreen/HS/Calender/Calender.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/Cards/user_event_card.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bar_controller.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_icons_bars_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../../../Widgets/Container/Post_Container.dart';
import '../FeedDetailsScreen/Feed_Details.dart';
import '../MyProfile/Profile.dart';

class HomeScreenBottom extends StatefulWidget {
  const HomeScreenBottom({super.key});

  @override
  State<HomeScreenBottom> createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {

  final AppColors appColors = Get.put(AppColors());
  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  final AppTabBarIconsController appTabBarIconsController = Get.put(AppTabBarIconsController());
  AddEventController addEventController = Get.put(AddEventController());

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
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(ApiUrl.appLogo, height: 35,fit: BoxFit.contain,),
            const Spacer(),
            Text(
              ApiUrl.appName,
              style: Theme.of(context).textTheme.bodyRegular
                  .copyWith(color: AppColors.text),
            ),
            Spacer(),
          ],
        ),
        actions: [
          InkWell(
            onTap: (){
              Get.to(Calender(),transition: Transition.fadeIn,duration: Duration(milliseconds: 200));
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appColors.selectedColor.value.withValues(alpha: 0.1),
              ),
              child: Center(child: SvgPicture.string(AppSvgs.calenderColoredGujarati),),
            ),
          ),
          SizedBox(width: 12,),
          GestureDetector(
              onTap: (){
                Get.to(Profile(profileImg: '', userName: '', country: '', phoneNumber: '', profession: '', maritalStatus: '', dateOfBirth: '', permanentLocation: '', residentLocation: '',), transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 100),);
              },
              child: Image.asset("assets/images/Profile_Icon.png",height: 40,width: 40,)),
          SizedBox(width: 16,),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 12,
            children: [
              Obx(() => CarouselSlider.builder(
                itemCount: addEventController.listOfEvent.length,
                itemBuilder: (context, index, realIndex) {
                  final event = addEventController.listOfEvent[index];
                  return UserEventCard(
                    date: DateFormat("MMM dd").format(DateTime.parse(event["start_datetime"])),
                    eventName: event["title"],
                    time: "Friday, 5:00PM to 7:30PM",
                    location: event["location"],
                    isLive: isEventLive(
                      event["start_datetime"],
                      event["end_datetime"],
                    ),
                    image: event['img'] ?? "assets/images/no-image.png",
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
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              )),
              // UserEventCard(date: "Nov25", eventName: "Event Name", time: "Friday, 5:00PM to 7:30PM", location: "123 Anywhere St., Any City",isLive: true,),
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
                           // adminHomeScreenController.getPost(typeMsg: "admin-notification");
                         }
                         else if (index == 2){
                           adminHomeScreenController.getPost(typeMsg: "");
                         }
                       },
                     ),
                   ),

                   ListView.builder(
                     physics: const NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                     itemCount: adminHomeScreenController.listOfPost.length,
                     itemBuilder: (context, index) {
                       final post = adminHomeScreenController.listOfPost[index];
                       return Obx(() => InkWell(
                         onTap: (){
                           Get.to(FeedDetails(
                             postMsg: post["content"],
                             profileImg: post["posted_by"]["profile_img"] ?? "assets/images/no-image.png",
                             name: '${post["posted_by"]["name"]} ${post["posted_by"]["surname"]}',
                             postTime: adminHomeScreenController.getTimeDifferenceAsString("${post["datetime"]}"),
                             postId: post["id"],
                             likeNumber: post["likes"],
                             commentNumber: post["comments"],
                             index: index,
                             memberId: post["posted_by"]["id"] ?? "",
                             likeSvg: adminHomeScreenController.likeData[index] ? AppSvgs.likeFilled :AppSvgs.likeOutline,
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
                             Get.to(Profile(
                               profileImg: post["posted_by"]["profile_img"] ?? "assets/images/no-image.png",
                               userName: "${post["posted_by"]?["name"] ?? ""} ${post["posted_by"]?["surname"] ?? ""}",
                               country: 'iiii',
                               phoneNumber: post["posted_by"]["mobile_no"] ?? "",
                               profession: post["posted_by"]["profession"] ?? "",
                               maritalStatus: 'mmmmm',
                               dateOfBirth: post["posted_by"]["dob"] ?? "",
                               permanentLocation: 'sjhdj',
                               residentLocation: 'sdsd',

                             ),duration: Duration(milliseconds: 100),transition: Transition.fadeIn);
                           },
                         ),
                       ),
                       );
                     },
                   ),
                 ],
               );
             },)
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: ActiveIconButton(
          onTap: () {
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
          text: "Create Post",
          icon: AppSvgs.add,
        ),
      ),
    );
  }
}
