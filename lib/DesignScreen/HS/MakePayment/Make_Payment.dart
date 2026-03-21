import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Make Payment",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.backgroundGradient,
                          border: Border.all(
                            width: 1,
                            color: appColors.selectedColor.value,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.white.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          child: Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10,),
                              SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: SvgPicture.string(AppSvgs.makePayment)),
                              Text("Sadharan",style: Theme.of(context).textTheme.body2SemiBold.copyWith(color: appColors.selectedColor.value),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },),
            ),
            Text("Pay Now",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: appColors.selectedColor.value.withValues(alpha: 0.30),
                    blurRadius: 5,
                    offset: Offset(0, 0),
                    spreadRadius: 0
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sadharan",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                    Text("₹1,50,000",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),),
                  ],
                ),
              ),
            ),
            Text("Transaction",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 15,
                itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6,top: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: appColors.selectedColor.value.withValues(alpha: 0.3),
                          offset: Offset(0, 0),
                          spreadRadius: 0
                        ),
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sadharan",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("₹1,50,000",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),),
                              Text("04:45PM",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },),
            )
          ],
        ),
      ),
    );
  }
}
