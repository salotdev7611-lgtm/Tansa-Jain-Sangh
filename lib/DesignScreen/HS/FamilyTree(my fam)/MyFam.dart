import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/Add_Relation_Controller.dart';
import 'package:family_app/DesignScreen/HS/FamilyTree(my%20fam)/My_Fam_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import 'Add_Relation.dart';

class MyFam extends StatefulWidget {
  const MyFam({super.key});

  @override
  State<MyFam> createState() => _MyFamState();
}

class _MyFamState extends State<MyFam> {

  final MyFamController myFamController = Get.put(MyFamController());
  final AddRelationController addRelationController = Get.put(AddRelationController());
  final AppColors appColors = Get.put(AppColors());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFamController.getMember();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Text("My Fam",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        actions: [
          GestureDetector(
              onTap: (){
                addRelationController.lastName.dropDownValue = DropDownValueModel(
                    name: myFamController.listOfMember[0]["surname"],
                    value: myFamController.listOfMember[0]["surname"]
                );
                addRelationController.wifeSurname.dropDownValue = DropDownValueModel(
                    name: myFamController.listOfMember[0]["surname"],
                    value: myFamController.listOfMember[0]["surname"]);
                Get.to(AddRelation(),transition: Transition.fadeIn,duration: Duration(milliseconds: 300));
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: appColors.selectedColor.value
                  ),
                  child: SvgPicture.string(AppSvgs.add,height: 30,width: 30,color: AppColors.white,))),
          SizedBox(width: 16,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
        child: Obx(()  {
          if(myFamController.get.value){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(myFamController.listOfMember.isEmpty){
            return Center(child: Text("No Data Found"),);
          }
          else{
            return Column(
              spacing: 18,
              children: [
                Container(
                  height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff14453D33).withValues(alpha: 0.8),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ]
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image:
                          myFamController.listOfMember[0]["profile_img"] == null
                              ? AssetImage("assets/images/no-image.png")
                              : NetworkImage(myFamController.listOfMember[0]["profile_img"] ?? ""),
                              fit: BoxFit.contain
                          ),),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 12,),
                          Text("${myFamController.listOfMember[0]["name"]} ${myFamController.listOfMember[0]["surname"]}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["mobile_no"]}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(myFamController.listOfMember[0]["dob"])),style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["blood_group"]}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                        ],
                      ),
                    ],
                  ),
                ),
                myFamController.listOfMember[0]["husband_wife_of"] == null
                ? SizedBox()
                : Container(
                  height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff14453D33).withValues(alpha: 0.8),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ]
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image:
                          myFamController.listOfMember[0]["husband_wife_of"]["profile_img"] == null
                              ? AssetImage("assets/images/no-image.png")
                              : NetworkImage(myFamController.listOfMember[0]["husband_wife_of"]?["profile_img"] ?? ""),
                              fit: BoxFit.contain
                          ),),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 12,),
                          Text("${myFamController.listOfMember[0]["husband_wife_of"]?["name"] ?? ""} ${myFamController.listOfMember[0]["husband_wife_of"]?["surname"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["husband_wife_of"]?["mobile_no"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(myFamController.listOfMember[0]["husband_wife_of"]?["dob"] ?? "")),style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["husband_wife_of"]?["blood_group"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff14453D33).withValues(alpha: 0.8),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ]
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image:
                         myFamController.listOfMember[0]["father"]["profile_img"] == null
                              ? AssetImage("assets/images/no-image.png")
                              : NetworkImage(myFamController.listOfMember[0]["father"]["profile_img"]),
                              fit: BoxFit.contain
                          ),),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 12,),
                          Text("${myFamController.listOfMember[0]["father"]["name"]} ${myFamController.listOfMember[0]["father"]["surname"]}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["father"]["mobile_no"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          myFamController.listOfMember[0]["father"]["dob"] == null
                          ? SizedBox()
                          : Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(myFamController.listOfMember[0]["father"]["dob"])),style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["father"]["blood_group"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff14453D33).withValues(alpha: 0.8),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ]
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image:
                         myFamController.listOfMember[0]["mother"]["profile_img"] == null
                              ? AssetImage("assets/images/no-image.png")
                              : NetworkImage(myFamController.listOfMember[0]["mother"]["profile_img"]),
                              fit: BoxFit.contain
                          ),),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 12,),
                          Text("${myFamController.listOfMember[0]["mother"]["name"]} ${myFamController.listOfMember[0]["mother"]["surname"]}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          Text("${myFamController.listOfMember[0]["mother"]["mobile_no"] ?? ""}",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),
                          myFamController.listOfMember[0]["mother"]["dob"] == null
                          ? SizedBox()
                          : Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(myFamController.listOfMember[0]["mother"]["dob"] ?? "")),style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text,),),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },)
      ),
    );
  }
}
