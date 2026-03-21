import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/MyFam.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Home_Screen_Bottom_Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../Chat/Chat_All.dart';
import '../ContactsDetails/Contacts.dart';
import '../FamilyTree(my fam)/tree.dart';
import '../Parentage/Parentage.dart';
import '../vidhi/Vidhi.dart';
import 'Home_Screen_Bottom.dart';

class BottomNavBarDrawer extends StatefulWidget {
  const BottomNavBarDrawer({super.key});

  @override
  State<BottomNavBarDrawer> createState() => _BottomNavBarDrawerState();
}

class _BottomNavBarDrawerState extends State<BottomNavBarDrawer> {
  int _currentIndex = 0;

  final AppColors appColors = Get.put(AppColors());

  final List<Widget> screens = [
    HomeScreenBottomDrawer(),
    Contacts(automaticallyImplyLeading: false, isFormConnect: false,),
    ChatAll(),
    Parentage(),
    Vidhi(automaticallyImplyLeading: false,),
    MyFam(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
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
  }
}
