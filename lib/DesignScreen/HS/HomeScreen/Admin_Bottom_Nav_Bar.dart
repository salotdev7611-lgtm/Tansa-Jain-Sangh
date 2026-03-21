import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/Chat/Chat_All.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/MyFam.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen.dart';
import 'package:family_app/DesignScreen/HS/Parentage/Parentage.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Vidhi.dart';
import 'package:family_app/DesignScreen/HS/MyFeed/My_Feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../FamilyTree(my fam)/tree.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = 0;
  int _newIndex = 0;
  final AdminSettingController adminSettingController = Get.put(AdminSettingController());

  final AppColors appColors = Get.put(AppColors());




  @override
  Widget build(BuildContext context) {
    List<Widget> screens = adminSettingController.status.value == true
        ? [
      AdminHomeScreen(),
      Contacts(automaticallyImplyLeading: false, isFormConnect: false,),
      ChatAll(),
      Parentage(),
      Vidhi(automaticallyImplyLeading: false),
      MyFam(),
    ]
        : [
      AdminHomeScreen(),
      Contacts(automaticallyImplyLeading: false, isFormConnect: false,),
      Parentage(),
      Vidhi(automaticallyImplyLeading: false),
      FamilyTreePage2(),
    ];
    // if (_currentIndex >= screens.length) {
    //   _currentIndex = 0;
    // }
    return Obx(() {
      return Scaffold(
        extendBody: true,
        backgroundColor: AppColors.white,
        body: IndexedStack(
          index: adminSettingController.status.value == true ? _currentIndex : _newIndex,
          children: screens,
        ),

        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: appColors.selectedColor.value,
          buttonBackgroundColor: appColors.selectedColor.value,

          items: [
            CurvedNavigationBarItem(
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: SvgPicture.string(AppSvgs.home, color: AppColors.white)),
              label: 'Home',
              labelStyle: Theme.of(context).textTheme.body4SemiBold
                  .copyWith(color: AppColors.white),
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: SvgPicture.string(AppSvgs.bottom, color: AppColors.white)),
              label: 'Contacts',
              labelStyle: Theme.of(context).textTheme.body4SemiBold
                  .copyWith(color: AppColors.white),
            ),
            if(adminSettingController.status.value == true)
              CurvedNavigationBarItem(
                child: SizedBox(
                    height: 28,
                    width: 28,
                    child: SvgPicture.string(AppSvgs.chat, color: AppColors.white)),
                label: 'Chat',
                labelStyle: Theme.of(context).textTheme.body4SemiBold
                    .copyWith(color: AppColors.white),
              ),
            CurvedNavigationBarItem(
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: SvgPicture.string(AppSvgs.treeUser, color: AppColors.white)),
              label: 'Parentage',
              labelStyle: Theme.of(context).textTheme.body4SemiBold
                  .copyWith(color: AppColors.white),
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: SvgPicture.string(AppSvgs.vidhi, color: AppColors.white)),
              label: 'Vidhi',
              labelStyle: Theme.of(context).textTheme.body4SemiBold
                  .copyWith(color: AppColors.white),
            ),
            CurvedNavigationBarItem(
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: SvgPicture.string(AppSvgs.family, color: AppColors.white)),
              label: 'MY FAM',
              labelStyle: Theme.of(context).textTheme.body4SemiBold
                  .copyWith(color: AppColors.white),
            ),
          ],

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    },);
  }
}
