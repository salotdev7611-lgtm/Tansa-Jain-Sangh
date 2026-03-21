import 'package:expandable_text/expandable_text.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class VidhiCard extends StatefulWidget {
  final String vidhiName;
  final String date;
  final String gujaratiDate;
  final String description;
  const VidhiCard({super.key, required this.vidhiName, required this.date, required this.gujaratiDate, required this.description,});

  @override
  State<VidhiCard> createState() => _VidhiCardState();
}

class _VidhiCardState extends State<VidhiCard> {

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.selectedColor.value.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: Offset(0, 0)
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vidhiName,
                    style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat("dd MMM, yyyy").format(DateTime.parse(widget.date)),
                        style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                      ),
                      Text(
                        widget.gujaratiDate,
                        style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                      ),
                    ],
                  )
                ],
              ),
              ExpandableText(
                expandText: "Read More",
                collapseText: "Read Less",
                linkStyle: Theme.of(context).textTheme.body2SemiBold.copyWith(color: appColors.selectedColor.value),
                maxLines: 4,
                linkEllipsis: false,
                "Lorem ipsum dolor sit amet consectetur. Sed bibendum at mauris diam sed congue vestibulum ac. Blandit ut id consectetur tempor in nulla. Arcu purus risus quam eu faucibus pulvinar amet. Ultricies amet dictum vestibulum vitae pharetra egestas erat."
                    "Lorem ipsum dolor sit amet consectetur. Sed bibendum at mauris diam sed congue vestibulum ac. Blandit ut id consectetur tempor in nulla. Arcu purus risus quam eu faucibus pulvinar amet. Ultricies amet dictum vestibulum vitae pharetra egestas erat.",
                style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
