import 'package:family_app/DesignScreen/HS/Calender/Calender_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:shimmer/shimmer.dart';

import '../../../TextTheme/text_theme.dart';
import 'Calender_Post_Model.dart';

class Calender extends StatefulWidget {
  Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {

  final AppColors appColors = Get.put(AppColors());
  final CalenderController calenderController = Get.put(CalenderController());
  DateTime now = DateTime.now();
  DateTime selectedMonth = DateTime.now();

  String present = DateFormat("yyyy-MM-dd").format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calenderController.getCalender(
        month: selectedMonth.month.toString(),
      year: DateFormat.y().format(now).toString(),
    );
    calenderController.dayCalender(date: present);
  }

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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Obx(() {
              if (calenderController.isLoading.value) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 300,
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }

              final list =
                  calenderController.calenderModel.value.data ?? [];

              final dateMap = {
                for (var item in list)
                  "${item.date?.year}-${item.date?.month}-${item.date?.day}":
                  item
              };

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: appColors.selectedColor.value
                          .withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.single,
                    /// 🔥 CORRECT SIGNATURE (VERY IMPORTANT)
                    dayBuilder: ({
                      required DateTime date,
                      BoxDecoration? decoration,
                      TextStyle? textStyle,
                      bool? isSelected,
                      bool? isDisabled,
                      bool? isToday,
                    }) {
                      final key =
                          "${date.year}-${date.month}-${date.day}";
                      final matchedData = dateMap[key];

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
                                style: Theme.of(context).textTheme.bodyBold.copyWith(
                                  color: isToday == true
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),

                              Text(
                                matchedData?.month ?? "",
                                style: Theme.of(context).textTheme.body1Regular.copyWith(
                                  fontSize: 10,
                                  color: isToday == true ? AppColors.white : AppColors.text,
                                ),
                              ),

                              Text(
                                matchedData?.tithi ?? "",
                                style: Theme.of(context).textTheme.body1Regular.copyWith(
                                  fontSize: 10,
                                  color: isToday == true
                                      ? AppColors.white
                                      : AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  value: const [],

                  /// 🔥 DATE CLICK
                  onValueChanged: (dates) {
                    if (dates.isNotEmpty && dates.first != null) {
                      final d = dates.first!;
                      final key = "${d.year}-${d.month}-${d.day}";
                      final selected = dateMap[key];

                      print("Selected Date: $d");
                      print("Month: ${selected?.month}");
                      print("Tithi: ${selected?.tithi}");
                      calenderController.dayDate.clear();
                      calenderController.dayDate.value = [];
                      present = DateFormat("yyyy-MM-dd").format(d);
                      calenderController.dayCalender(date: present);
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 20),

            /// 🔥 TODAY INFO BOX
            Obx(() {
              if(calenderController.isLoading.value){
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 60,
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
              else if(calenderController.dayDate.isNotEmpty){
                return Container(
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
                            Text(DateFormat("dd-MMMM-yyyy").format(DateTime.parse(calenderController.dayDate[0]["date"])),style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),
                            Text(DateFormat('EEEE').format(DateTime.now()),style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),
                          ],
                        ),
                        Text("${calenderController.dayDate[0]["month"]} ${calenderController.dayDate[0]["tithi"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),),


                      ],
                    ),
                  ),
                );
              }
              else {
                return SizedBox();
              }
            }),
            const SizedBox(height: 20),

            Obx(() {
              if(calenderController.isLoading.value){
                return  Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 60,
                    width: Get.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
              else if(calenderController.dayDate.isNotEmpty){
                return Container(
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
                            Text("Time",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                            Text("Suryoday : ${calenderController.dayDate[0]["suryoday"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                            Text("Suryast  : ${calenderController.dayDate[0]["Suryast"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Navkarshi : ${calenderController.dayDate[0]["navkarshi"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                            Text("Porsi : ${calenderController.dayDate[0]["porsi"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                            Text("Saadhporsi  :  ${calenderController.dayDate[0]["saadhporsi"]}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              else{
                return SizedBox();
              }
            })
          ],
        ),
      ),
    );
  }
}
