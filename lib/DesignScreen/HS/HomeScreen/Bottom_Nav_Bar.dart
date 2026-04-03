import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:family_app/DesignScreen/HS/Chat/Chat_All.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Home_Screen_Bottom.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Vidhi.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';

import '../MyProfile/Profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int _currentIndex = 0;

  final List<Widget> screens = [
    HomeScreenBottom(),
    Contacts(automaticallyImplyLeading: false,),
    ChatAll(),
    Center(child: Text("Parentage Screen")),
    Vidhi(automaticallyImplyLeading: false,),
    Center(child: Text("My Family Screen")),
  ];

  final AppColors appColors = Get.put(AppColors());
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

