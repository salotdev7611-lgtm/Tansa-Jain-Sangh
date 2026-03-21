import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminEventCard extends StatefulWidget {
  final String title;
  final String desc;
  final String date;
  final String location;
  const AdminEventCard({super.key, required this.title, required this.desc, required this.date, required this.location});

  @override
  State<AdminEventCard> createState() => _AdminEventCardState();
}

class _AdminEventCardState extends State<AdminEventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: 100.w,
        // height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white,width: 1),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            )
          ]
        ),
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    DateFormat("MMM").format(DateTime.parse(widget.date)).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white)
                  ),
                  Text(
                    DateFormat("dd").format(DateTime.parse(widget.date)),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white)
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodySemiBold.copyWith(color: AppColors.text),
                    ),
                    Text(
                      widget.desc,
                      style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.string(AppSvgs.time,width: 16,height: 16,colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),),
                        Text(
                          DateFormat("hh:mm a").format(DateTime.parse(widget.date)),
                          style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),
                        )
                      ],
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        SvgPicture.string(AppSvgs.locationPin1,width: 16,height: 16,colorFilter: ColorFilter.mode(AppColors.grey, BlendMode.srcIn),),
                        Text(
                          widget.location,
                          style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
