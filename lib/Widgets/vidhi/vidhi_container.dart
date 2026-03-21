import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';

class VidhiContainer extends StatefulWidget {
  const VidhiContainer({super.key, required this.vidhiName, required this.date, required this.tithi, required this.description});
  final String vidhiName;
  final String date;
  final String tithi;
  final String description;



  @override
  State<VidhiContainer> createState() => _VidhiContainerState();
}

class _VidhiContainerState extends State<VidhiContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [ BoxShadow(
              color: Color(0xff14453D33).withValues(alpha: 0.2),
              offset: const Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 0
          ),
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.vidhiName,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                      Text(widget.tithi,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Text(widget.date,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                  //   ],
                  // ),
                ],
              ),
              Text(widget.description,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text,),maxLines: 3,overflow: TextOverflow.ellipsis,)
            ],
          ),
        ),
      ),
    );
  }
}
