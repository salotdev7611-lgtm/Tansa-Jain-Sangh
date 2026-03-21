import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_surname_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Helpers/app_colors.dart';
import '../../TextTheme/text_theme.dart';

class AppTabSurname extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  const AppTabSurname({super.key, required this.items, required this.selectedIndex});

  @override
  State<AppTabSurname> createState() => _AppTabSurnameState();
}

class _AppTabSurnameState extends State<AppTabSurname> {

  final AppColors appColors = Get.put(AppColors());
  AppTabSurnameController appTabSurnameController = Get.put(AppTabSurnameController());
  final AdminSettingController adminSettingController = Get.put(AdminSettingController());
  final AddVidhiController addVidhiController = Get.put(AddVidhiController());

  @override
  void initState() {
    appTabSurnameController.selectedIndex.value = widget.selectedIndex;
    super.initState();
    getData();
  }
  void getData() async  {
   await  adminSettingController.getSurname();
   int i = adminSettingController.listOfSurname.value.indexWhere((element) =>(element["surname"]??"") == addVidhiController.userSurname.value);
   if(i!=-1){
     appTabSurnameController.selectedIndex.value = i;

   }
   // appTabSurnameController.selectedIndex.value =0;

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() =>  Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: adminSettingController.listOfSurname.length,
                itemBuilder: (context,index){
                  final surname = adminSettingController.listOfSurname[index];
                  return  Obx(() => GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      appTabSurnameController.selectedIndex.value = index;
                      addVidhiController.getVidhi(surname: surname["surname"]);
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: appTabSurnameController.selectedIndex.value == index ? appColors.selectedColor.value : AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: appTabSurnameController.selectedIndex.value == index ? appColors.selectedColor.value : AppColors.white)
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                          child: Text(
                            surname["surname"].toString(),
                            style: Theme.of(context).textTheme.bodyRegular.copyWith(
                                color: appTabSurnameController.selectedIndex.value == index ? AppColors.white : appColors.selectedColor.value
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),);
                }),
          ),),
        ],
      ),
    );
  }
}
