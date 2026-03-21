import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event.dart';
import 'package:family_app/DesignScreen/HS/ManageEvent/Add_Event_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/Dilog/Delete_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.title, required this.image, required this.location, required this.dateTime, required this.description, required this.id, required this.endTime, required this.link});
  final String id;
  final String title;
  final String image;
  final String location;
  final String dateTime;
  final String endTime;
  final String description;
  final String link;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  final AddEventController addEventController = Get.put(AddEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.title,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        actions: [
          InkWell(
            onTap: (){
              int endHour = int.parse(DateFormat("HH").format(DateTime.parse(widget.endTime)),);

              if (endHour < 12) {
                // addEventController.isAmSelected.value = false;
                addEventController.isPmSelected.value = true;
              }
              else {
                addEventController.isPmSelected.value = false;
              }

              addEventController.updateEvent.value = true;
              addEventController.event.value = widget.image;
              addEventController.eventName.text = widget.title;
              addEventController.location.text = widget.location;
              addEventController.description.text = widget.description;
              addEventController.startDate.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.dateTime));
              addEventController.endDate.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.endTime));
              addEventController.startTime.text = DateFormat("hh").format(DateTime.parse(widget.dateTime));
              addEventController.startMin.text = DateFormat("mm").format(DateTime.parse(widget.dateTime));
              addEventController.endTime.text = DateFormat("hh").format(DateTime.parse(widget.endTime));
              addEventController.endMin.text = DateFormat("mm").format(DateTime.parse(widget.endTime));
              addEventController.liveLink.text = widget.link;
              print(" image ${widget.image}");
              Get.to(AddEvent(eventId: widget.id,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.string(AppSvgs.editColored),
              ),
            ),
          ),
          SizedBox(width: 8,),
          InkWell(
            onTap: (){
              Get.dialog(Dialog(
                child: DeleteDialog(title: "Delete Event", description: "Are you sure you want to delete ‘${widget.title}’? ",
                    yesOnTap: () async {
                  await addEventController.eventDelete(id: widget.id);
                    }),
              ));
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.string(AppSvgs.deleteFilled),
              ),
            ),
          ),
          SizedBox(width: 16,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  width: Get.width,
                  child: Image.network(widget.image,fit: BoxFit.contain,)),
              // Image.asset("assets/images/event_banner.png"),
              SizedBox(height: 12,),
              Row(
                children: [
                  SvgPicture.string(AppSvgs.locationPin1),
                  Text(widget.location),
                ],
              ),
              SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(text: TextSpan(
                        text: DateFormat("dd MMM").format(DateTime.parse(widget.dateTime)),
                        style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.text),
                        children: [
                          TextSpan(
                            text: "- ${DateFormat("hh:mm a").format(DateTime.parse(widget.dateTime))} to ${DateFormat("hh:mm a").format(DateTime.parse(widget.endTime))}",
                            style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                          ),
                        ]
                      )),
                    ],
                  ),
                  widget.link.isNotEmpty?
                  ActiveIconButton(onTap: () async {
                    final uri = Uri.parse(widget.link);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }, text: "Watch Live", icon: AppSvgs.arrow)
                      : SizedBox()
                ],
              ),
              SizedBox(height: 12,),
              Text(widget.description,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),textAlign: TextAlign.justify,)
            ],
          ),
        ),
      ),
    );
  }
}
