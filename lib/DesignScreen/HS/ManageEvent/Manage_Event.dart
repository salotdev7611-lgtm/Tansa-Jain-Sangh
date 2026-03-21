import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Event_Details.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/Cards/admin_event_card.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bar_controller.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageEvent extends StatefulWidget {
  const ManageEvent({super.key});

  @override
  State<ManageEvent> createState() => _ManageEventState();
}

class _ManageEventState extends State<ManageEvent> {

  final AddEventController addEventController = Get.put(AddEventController());
  AppTabBarController appTabBarController = Get.put(AppTabBarController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addEventController.eventGet(status: 'upcoming');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Events",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 40,
                width: Get.width,
                child: AppTabBars(items: ["Upcoming","Live","Past"], selectedIndex: appTabBarController.selectedIndex.value,
                  onTap: (int index) {
                      appTabBarController.selectedIndex.value = index;
                      print(appTabBarController.selectedIndex);
                      if(index == 0){
                        addEventController.eventGet(status: 'upcoming');
                      }
                      else if(index == 1){
                        addEventController.eventGet(status: 'live');
                      }
                      else{
                        addEventController.eventGet(status: 'past');
                      }
                  },)),
            Obx(() =>  appTabBarController.selectedIndex.value == 0 ? Text("Upcoming Events",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.text),)
                : appTabBarController.selectedIndex.value == 1 ? Text("Live Events",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.text),)
                : Text("Past Events",style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.text),),),

            Obx(() {
              if(addEventController.get.value) {
                  return Center(child: CircularProgressIndicator());
              }
              if(addEventController.listOfEvent.isEmpty){
                return Text("No Events");
              }
              else {
                return Expanded(child:  ListView.builder(
                itemCount: addEventController.listOfEvent.length,
                  itemBuilder: (context, index) {
                    final event = addEventController.listOfEvent[index];
                    return InkWell(
                        onTap: (){
                          Get.to(EventDetails(title: event["title"], image: event["img"], location: event["location"], dateTime: event["start_datetime"], description: event["description"], id: event["id"], endTime: event["end_datetime"], link: event["live_url"],),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                        },
                        child: AdminEventCard(title: event['title'].toString(), desc: event["description"].toString(), date: event["start_datetime"], location: event["location"],));
                  },));
              }
            },)

          ],
        ),
      ),
      floatingActionButton: ActiveIconButton(onTap: (){
        Get.to(AddEvent(eventId: '',),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
      }, text: " Add Event ", icon: AppSvgs.add),
    );
  }
}
