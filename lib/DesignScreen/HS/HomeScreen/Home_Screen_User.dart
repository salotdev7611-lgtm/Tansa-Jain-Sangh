import 'package:carousel_slider/carousel_slider.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../Helpers/api_url.dart';
import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../../../Widgets/Cards/user_event_card.dart';
import '../../../Widgets/Container/Home_Container.dart';
import '../../../Widgets/Container/Post_Container.dart';
import '../../../Widgets/CustomTabs/app_tab_icons_bars.dart';
import '../Calender/Calender.dart';
import '../FamilyTree(my fam)/tree.dart';
import '../FeedDetailsScreen/Feed_Details.dart';
import '../ContactsDetails/Contacts.dart';
import '../MyProfile/Profile.dart';
import '../Parentage/Parentage.dart';
import '../vidhi/Vidhi.dart';

class HomeScreenUser extends StatefulWidget {
  const HomeScreenUser({super.key});

  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {

  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
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
              const Spacer(),
            ],
          ),
        actions: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                  itemCount: 6,
                  itemBuilder: (context, index, realIndex) {
                    return UserEventCard(
                      date: "Nov25",
                      eventName: "Event Name",
                      time: "Friday, 5:00PM to 7:30PM",
                      location: "123 Anywhere St., Any City",
                      isLive: index == 0 ? true : false, image: '',);
                  },
                  options: CarouselOptions(
                    // height: 400,
                    aspectRatio: 16/9,
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
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("HeritageHub",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("13 Sep,’25 Saturday",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                      Text("Bhadrva Sud, 6",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                    ],
                  )
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(child: InkWell(
                      onTap: (){
                        loginScreenController.addVidhi.value = false;
                        Get.to(
                          Vidhi(automaticallyImplyLeading: true,),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                      child: HomeContainer(image: "", svg: AppSvgs.vidhi, name: "Vidhi"))),

                  Expanded(child: InkWell(
                      onTap: (){
                        Get.to(
                          Parentage(),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                      child: HomeContainer(image: "", svg: AppSvgs.treeUser, name: "Parentage"))),

                  Expanded(child: InkWell(
                      onTap: (){
                        Get.to(
                          Calender(),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                      child: HomeContainer(image: "", svg: AppSvgs.calenderGujarati, name: "Calender"))),

                  Expanded(child: InkWell(
                      onTap: (){
                        loginScreenController.addVidhi.value = false;
                        Get.to(
                          Contacts(automaticallyImplyLeading: true,),
                          transition: Transition.fadeIn,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                      child: HomeContainer(image: "", svg: AppSvgs.contact, name: "Contacts"))),


                  Expanded(child: InkWell(
                      onTap: (){
                        Get.to(FamilyTreePage2(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                      },
                      child: HomeContainer(image: "", svg: AppSvgs.family, name: "My Fam"))),
                ],
              ),

              /// show here
              // SizedBox(
              //   height: 40,
              //   child: AppTabIconsBars(
              //     items: ["Feed" , "Favorite" , "Admin MSG"],
              //     icons: [AppSvgs.note, AppSvgs.bookMarkOutlineStared, AppSvgs.user],
              //     selectedIndex: 0,
              //   ),
              // ),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Obx(() => InkWell(
                    onTap: (){
                      Get.to(FeedDetails(postMsg: '', profileImg: '', name: '', postTime: '', postId: '', likeNumber: '', commentNumber: '', index: index, memberId: '',
                          likeSvg: adminHomeScreenController.likeData[index] ? AppSvgs.likeFilled :AppSvgs.likeOutline
                      ),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: PostContainer(
                      postId: '',
                      profileImg: "assets/images/person.jpg",
                      userName: "userName",
                      memberId: '',
                      time: "time",
                      svgComment: AppSvgs.comment,
                      description:
                      "Lorem ipsum dolor sit amet consectetur. Porta pellentesque aliquet arcu orci cras lectus. Non sit tristique pellentesque posuere faucibus habitasse aliquam bibendum faucibus. Adipiscing vestibulum tellus aliquet morbi odio duis faucibus. Condimentum risus est quis tellus volutpat lorem.",
                      likeNumber: "5",
                      commentNumber: "5",
                      saveSvg: adminHomeScreenController.saveListData[index]
                          ? AppSvgs.bookMarkFilledStared
                          : AppSvgs.bookmarkOutline,
                      index: index,
                      likeSvg: adminHomeScreenController.likeData[index] ? AppSvgs.likeFilled :AppSvgs.likeOutline,
                      onTapCall: () {
                        Get.to(Profile(profileImg: '', userName: '', country: '', phoneNumber: '', profession: '', maritalStatus: '', dateOfBirth: '', permanentLocation: '', residentLocation: '',),duration: Duration(milliseconds: 100),transition: Transition.fadeIn);
                      },
                    ),
                  ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
    );
  }
}
