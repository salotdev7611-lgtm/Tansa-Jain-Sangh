import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

import '../../../TextTheme/text_theme.dart';

class Calender extends StatelessWidget {
  Calender({super.key});

  // Gujarati Months
  final List<String> gujaratiMonths = const [
    "કારતક",
    "માગશર",
    "પોષ",
    "મહા",
    "ફાગણ",
    "ચૈત્ર",
    "વૈશાખ",
    "જેઠ",
    "અષાઢ",
    "શ્રાવણ",
    "ભાદરવો",
    "આસો",
  ];

  String getGujaratiMonth(int month) => gujaratiMonths[month - 1];

  // Krishna Paksha Tithi List (15)
  final List<String> krishnaPakshaTithis = const [
    "એકમ",
    "બીજ",
    "ત્રીજ",
    "ચોથ",
    "પાંચમ",
    "છઠ",
    "સાતમ",
    "આઠમ",
    "નોમ",
    "દશમ",
    "અગિયારશ",
    "બારસ",
    "તેરસ",
    "ચૌદસ",
    "અમાસ",
  ];

  // Return Krishna Paksha Tithi (cycle every 15 days)
  String getGujaratiTithi(DateTime date) {
    int index = (date.day - 1) % 15;
    return krishnaPakshaTithis[index];
  }

  final AppColors appColors = Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Calendar",
          style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
        ),
        backgroundColor: AppColors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Column(
          spacing: 16,
          children: [
            Obx(() => Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: appColors.selectedColor.value.withValues(alpha: 0.2),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0
                    ),
                  ]
              ),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.single,
                  selectedDayHighlightColor: Colors.deepPurple,

                  dayBuilder: ({
                    required DateTime date,
                    BoxDecoration? decoration,
                    TextStyle? textStyle,
                    bool? isSelected,
                    bool? isDisabled,
                    bool? isToday,
                  }) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected == true
                            ? Colors.deepPurple.withOpacity(0.25)
                            : isToday == true
                            ? appColors.selectedColor.value
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),

                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                date.day.toString(),
                                style: Theme.of(context).textTheme.bodyBold.copyWith(color: isToday == true ? AppColors.white : AppColors.text)
                            ),

                            // Gujarati Month
                            Text(
                                getGujaratiMonth(date.month),
                                style: Theme.of(context).textTheme.body1Regular.copyWith(color: isToday == true ? AppColors.white : AppColors.text)
                            ),

                            // Krishna Paksha Tithi
                            Text(
                                getGujaratiTithi(date),
                                style: Theme.of(context).textTheme.body1Regular.copyWith(color: isToday == true ? AppColors.white : AppColors.text)
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                value: const [],
                onValueChanged: (dates) {
                  print("Selected Gujarati Date: $dates");
                },
              ),
            ),),
            Obx(() => Container(
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(
                  color: appColors.selectedColor.value,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.selectedColor.value.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat("dd-MMMM-yyyy").format(DateTime.now()),style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),
                        Text(DateFormat('EEEE').format(DateTime.now()),style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),
                      ],
                    ),
                    Text("આસો આઠમ",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),),


                  ],
                ),
              ),
            ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: appColors.selectedColor.value.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sun Sign",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                        Text("Sun Rise :  6:48",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        Text("Sun Set  : 18:48",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                      ],
                    ),
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Moon Sign",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                        Text("Moon Rise : 18:48",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        Text("Moon Set  :  4:52",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: appColors.selectedColor.value.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Holiday/Festival",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Holiday :  No",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                            Text("Festival  : No",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                          ],
                        )
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
