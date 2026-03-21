import 'dart:math';

import 'package:family_app/DesignScreen/HS/ProfileBookMark/Book_Mark_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileBookMark extends StatefulWidget {
  const ProfileBookMark({super.key});

  @override
  State<ProfileBookMark> createState() => _ProfileBookMarkState();
}

class _ProfileBookMarkState extends State<ProfileBookMark> {

  final BookMarkController bookMarkController = Get.put(BookMarkController());
  final AppColors appColors = Get.put(AppColors());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookMarkController.getProfileBookMark();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Profile BookMark",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Obx(() {
        if(bookMarkController.get.value){
          return Center(child: CircularProgressIndicator());
        }
        if(bookMarkController.listOfBookMark.isEmpty){
          return Center(child: Text("No BookMark Add"),);
        }
        else{
          return ListView.builder(
            itemCount: bookMarkController.listOfBookMark.length,
            itemBuilder: (context, index) {
              final profileBookMark = bookMarkController.listOfBookMark[index]["bookmark_to"];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.selectedColor.value,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 12,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                image: DecorationImage(image:   profileBookMark["profile_img"].toString().isEmpty || profileBookMark["profile_img"] == null
                                    ?AssetImage("assets/images/no-image.png")
                                    : NetworkImage(profileBookMark["profile_img"]),
                                    fit: BoxFit.contain
                                )
                            )
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${profileBookMark["name"]} ${profileBookMark["surname"]}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white)),
                            Text("${profileBookMark["mobile_no"]}",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.white)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },);
        }
      }),
    );
  }
}
