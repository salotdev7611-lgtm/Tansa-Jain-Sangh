import 'package:carousel_slider/carousel_slider.dart';
import 'package:family_app/DesignScreen/HS/Calender/Calender.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/DesignScreen/HS/MyProfile/Profile.dart';
import 'package:family_app/DesignScreen/HS/Parentage/Parentage.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Cards/user_event_card.dart';
import 'package:family_app/Widgets/Container/Home_Container.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../Helpers/api_url.dart';
import '../vidhi/Vidhi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AddEventController addEventController = Get.put(AddEventController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addEventController.eventGet(status: "");
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(ApiUrl.appLogo,height: 40,width: 40,),
            Text(ApiUrl.appName,style: Theme.of(context).textTheme.bodyRegular.copyWith(color: AppColors.text),),
            GestureDetector(
                onTap: (){
                  Get.to(Profile(profileImg: '', userName: '', country: '', phoneNumber: '', profession: '', maritalStatus: '', dateOfBirth: '', permanentLocation: '', residentLocation: '',), transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 100),);
                },
                child: Image.asset("assets/images/Profile_Icon.png",height: 40,width: 40,)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      return Image.asset("assets/images/Banner.png");
                    },
                    options: CarouselOptions(
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
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("HeritageHub",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        Text("13 Sep,’25 Saturday",style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),),
                        Text("Bhadrva Sud, 6",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                      ],
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(child: InkWell(
                        onTap: (){
                          Get.to(
                            Vidhi(automaticallyImplyLeading: true,),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100),
                          );
                        },
                        child: HomeContainer(image: "assets/images/vidhi.png", svg: "", name: "Vidhi"))),

                    Expanded(child: InkWell(
                        onTap: (){
                          Get.to(
                            Parentage(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100),
                          );
                        },
                        child: HomeContainer(image: "assets/images/tree.png", svg: "", name: "Parentage"))),

                    Expanded(child: InkWell(
                        onTap: (){
                          Get.to(
                            Calender(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100),
                          );
                        },
                        child: HomeContainer(image: "", svg: AppSvgs.date, name: "Calender"))),

                    Expanded(child: InkWell(
                        onTap: (){
                          Get.to(
                            Contacts(automaticallyImplyLeading: true, isFormConnect: false,),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100),
                          );
                        },
                        child: HomeContainer(image: "assets/images/phonebook.png", svg: "", name: "Contacts"))),
                    Expanded(child: HomeContainer(image: "assets/images/family.png", svg: "", name: "My Fam")),
                  ],
                ),
                Text("Events",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                Obx(() => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: addEventController.listOfEvent.length,
                  itemBuilder: (context, index) {
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
                      image: event['img'],);
                  },),)
              ],
            ),
        ),
      ),
    );
  }
}
