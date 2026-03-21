import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Dilog/Delete_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsDetails extends StatefulWidget {
  const ContactsDetails({super.key, required this.name, required this.country, required this.city, required this.connectNo, required this.fullFamilyName, required this.profession, required this.maritalStatus, required this.dateOfBirth, required this.permanentLocation, required this.residentLocation, required this.image, required this.id});
  final String id;
  final String image;
  final String name;
  final String country;
  final String city;
  final String connectNo;
  final String fullFamilyName;
  final String profession;
  final String maritalStatus;
  final String dateOfBirth;
  final String permanentLocation;
  final String residentLocation;

  @override
  State<ContactsDetails> createState() => _ContactsDetailsState();
}

class _ContactsDetailsState extends State<ContactsDetails> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final ContactsController contactsController = Get.put(ContactsController());
  final AppColors appColors = Get.put(AppColors());

  Future<void> _callNumber(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle the case where the URL can't be launched (e.g. on a non-phone device)
      print('Could not launch $launchUri');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactsController.mainMemberDetails(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Member Details",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        actions: [
          Visibility(
              visible: loginScreenController.addVidhi.value,
              child: Row(
            spacing: 12,
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.text
                ),
                child: Center(
                    child: SvgPicture.string(AppSvgs.blockedUser,color: AppColors.white,)),
              ),
              InkWell(
                onTap: (){
                  Get.dialog(Dialog(
                    child: DeleteDialog(title: "Delete Person", description: "Are you sure you want to delete ‘Person Name’? ", yesOnTap: (){
                      Get.back();
                      Get.back();
                      Get.back();
                    }),
                  ));
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.red
                  ),
                  child: Center(
                      child: SvgPicture.string(AppSvgs.deleteOutline,color: AppColors.white,)),
                ),
              ),
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColors.selectedColor.value
                ),
                child: Center(
                    child: SvgPicture.string(AppSvgs.edit1,color: AppColors.white,)),
              ),
            ],
          ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
          child:Obx(() {
            if(contactsController.get.value){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withValues(alpha: 0.09),
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                        image: DecorationImage(image: NetworkImage(contactsController.listOfMemberDetails[0]["profile_img"] ?? ""),fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(AppSvgs.user),
                      Text("${contactsController.listOfMemberDetails[0]["name"] ?? ""} ${contactsController.listOfMemberDetails[0]["surname"] ?? ""}",style: Theme.of(context).textTheme.bodyBold,),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(AppSvgs.locationPin),
                      Text("${contactsController.listOfMemberDetails[0]["family_house_id"]?["country"] ?? ""} ${contactsController.listOfMemberDetails[0]["family_house_id"]?["city"] ?? ""}",style: Theme.of(context).textTheme.body1Regular,)
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      _callNumber(widget.connectNo);
                    },
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(AppSvgs.phone),
                        Text(contactsController.listOfMemberDetails[0]["mobile_no"] ?? "",style: Theme.of(context).textTheme.body1Regular,)
                      ],
                    ),
                  ),
                  // Text("Lorem ipsum dolor sit amet consectetur. Id cursus sed ornare neque felis quam id.",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text,),textAlign: TextAlign.center,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              contactsController.listOfMemberDetails[0]["total_posts"],
                              style: Theme.of(context).textTheme.headingSemiBold,
                            ),
                            Text(
                              "My Feed",
                              style: Theme.of(context)
                                  .textTheme
                                  .body1Light
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              contactsController.listOfMemberDetails[0]["total_bookmarks"],
                              style: Theme.of(context).textTheme.headingSemiBold,
                            ),
                            Text(
                              "Favorite",
                              style: Theme.of(context)
                                  .textTheme
                                  .body1Light
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              contactsController.listOfMemberDetails[0]["total_liked_posts"],
                              style: Theme.of(context).textTheme.headingSemiBold,
                            ),
                            Text(
                              "Likes",
                              style: Theme.of(context)
                                  .textTheme
                                  .body1Light
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text("Relations",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  Row(
                    spacing: 8,
                    children: [
                      contactsController.listOfMemberDetails.first["father"] == null
                          ? SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.grey,width: 2),
                                  image: DecorationImage(image: contactsController.listOfMemberDetails[0]["father"]["profile_img"] == null || contactsController.listOfMemberDetails[0]["father"]["profile_img"] == ""
                                      ? AssetImage("assets/images/no-image.png")
                                      : NetworkImage(contactsController.listOfMemberDetails[0]["father"]["profile_img"]),
                                      fit: BoxFit.contain
                                  )
                              ),
                            ),
                          ),
                          Center(child: Text("${contactsController.listOfMemberDetails[0]["father"]?["name"] ?? ""} ${contactsController.listOfMemberDetails[0]["father"]?["surname"] ?? ""}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),)),
                          Center(child: Text("Father")),
                        ],
                      ),
                      contactsController.listOfMemberDetails.first["father"] == null
                          ? SizedBox()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.grey,width: 2),
                                  image: DecorationImage(image: contactsController.listOfMemberDetails[0]["mother"]["profile_img"] == null || contactsController.listOfMemberDetails[0]["mother"]["profile_img"] == ""
                                      ? AssetImage("assets/images/no-image.png")
                                      : NetworkImage(contactsController.listOfMemberDetails[0]["mother"]["profile_img"]),
                                      fit: BoxFit.contain
                                  )
                              ),
                            ),
                          ),
                          Center(child: Text("${contactsController.listOfMemberDetails[0]["mother"]?["name"] ?? ""} ${contactsController.listOfMemberDetails[0]["mother"]?["surname"] ?? ""}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),)),
                          Center(child: Text("Mother")),
                        ],
                      ),
                      contactsController.listOfMemberDetails[0]["husband_wife_of"] == null
                      ?SizedBox()
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.grey,width: 2),
                                  image: DecorationImage(image: contactsController.listOfMemberDetails[0]["husband_wife_of"]["profile_img"] == null || contactsController.listOfMemberDetails[0]["husband_wife_of"]["profile_img"] == ""
                                      ? AssetImage("assets/images/no-image.png")
                                      : NetworkImage(contactsController.listOfMemberDetails[0]["husband_wife_of"]["profile_img"]),
                                      fit: BoxFit.contain
                                  )
                              ),
                            ),
                          ),
                          Center(child: Text("${contactsController.listOfMemberDetails[0]["husband_wife_of"]?["name"] ?? ""} ${contactsController.listOfMemberDetails[0]["husband_wife_of"]?["surname"] ?? ""}",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),)),
                          Center(child: Text(contactsController.listOfMemberDetails.first["husband_wife_of"]["gender"] == "m" ? "Husband" : "Wife")),
                        ],
                      ),
                    ],
                  ),
                  // Text("Full Family Name",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  // Text(widget.fullFamilyName,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),

                  Text("Profession",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  Text(contactsController.listOfMemberDetails[0]["profession"] ?? "",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Marital Status",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                          Text(contactsController.listOfMemberDetails[0]["husband_wife_of"] == null ? "Un-Married" : "Married",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        ],
                      ),
                      Spacer(),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date of Birth",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                          Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(contactsController.listOfMemberDetails[0]["dob"] ?? "")),style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        ],
                      ),
                      Spacer()
                    ],
                  ),
                  Text("Permanent Location",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  contactsController.listOfMemberDetails[0]["family_house_id"] == null
                  ? SizedBox()
                  :Text("${contactsController.listOfMemberDetails[0]["family_house_id"]["address"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["city"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["state"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["country"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["pincode"] ?? ""}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),

                  Text("Resident Location",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  contactsController.listOfMemberDetails[0]["family_house_id"] == null
                      ? SizedBox()
                      :Text("${contactsController.listOfMemberDetails[0]["family_house_id"]["address"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["city"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["state"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["country"] ?? ""}, ${contactsController.listOfMemberDetails[0]["family_house_id"]["pincode"] ?? ""}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),                ],
              );
            }
          },)
        ),
      ),
    );
  }
}
