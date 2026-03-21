import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class UserEventCard extends StatefulWidget {
  final bool? isLive;
  final String date;
  final String eventName;
  final String time;
  final String location;
  final String image;
  final String? liveLinkUrl;
  const UserEventCard({super.key, this.isLive = false, required this.date, required this.eventName, required this.time, required this.location, required this.image, this.liveLinkUrl});

  @override
  State<UserEventCard> createState() => _UserEventCardState();
}

class _UserEventCardState extends State<UserEventCard> {

  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 180,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            offset: Offset(0, 0),
            blurRadius: 4
          ),
        ],
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: widget.image.isNotEmpty
                  ? NetworkImage(widget.image)
                  : const AssetImage("assets/images/no-image.png"),
              fit: BoxFit.contain,
            ),
          ),

          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greenShade.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.isLive == true
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                          widget.isLive == true
                           ?Text(
                            "Live",
                            style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.primaryGreen),
                          )
                              : Text(
                            "Up-Coming",
                            style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.primaryGreen),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: appColors.selectedColor.value
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 0.5),
                                child: Text(
                                  widget.date,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                      : Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appColors.selectedColor.value
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 0.5),
                            child: Text(
                              widget.date,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body2Bold.copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.eventName,
                            style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
                          ),
                          Text(
                            widget.time,
                            style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              SvgPicture.string(AppSvgs.locationPin1,height: 15,width: 15,),
                              Text(
                                widget.location,
                                style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                              )
                            ],
                          )
                        ],
                      ),
                      widget.isLive == true &&
                          widget.liveLinkUrl != null &&
                          widget.liveLinkUrl!.isNotEmpty
                          ? ActiveIconButton(
                        onTap: () async {
                          final uri = Uri.parse(widget.liveLinkUrl!);
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        text: "Watch Live",
                        icon: AppSvgs.watchLive,
                      )
                          : SizedBox()
                      // if(widget.isLive == true && widget.liveLinkUrl != null)ActiveIconButton(
                      //   onTap: () {
                      //     launchUrl(Uri.parse(widget.liveLinkUrl!));
                      //     print("widget.liveLinkUrl ${widget.liveLinkUrl}");
                      //   },
                      //   text: "Watch Live",
                      //   icon: AppSvgs.watchLive,
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
