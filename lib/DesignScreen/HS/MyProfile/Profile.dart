import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Like_Post/Like_Post.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/ProfileBookMark/ProfileBookMark.dart';
import 'package:family_app/DesignScreen/HS/UpdateProfile/UpdateProfileController.dart';
import 'package:family_app/DesignScreen/HS/UpdateProfile/Update_Profile.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/DesignScreen/HS/MyFeed/My_Feed.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Widgets/RadioButtons/app_radio_button_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.profileImg, required this.userName, required this.country, required this.phoneNumber, required this.profession, required this.maritalStatus, required this.dateOfBirth, required this.permanentLocation, required this.residentLocation});

  final String profileImg;
  final String userName;
  final String country;
  final String phoneNumber;
  final String profession;
  final String maritalStatus;
  final String dateOfBirth;
  final String permanentLocation;
  final String residentLocation;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final UpdateProfileController updateProfileController = Get.put(UpdateProfileController());
  final   AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());

  Future<void> _callNumber(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $launchUri');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginScreenController.profileStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Profile",style: Theme.of(context).textTheme.bodyBold,),
        actions: [
          GestureDetector(
            onTap: (){
              updateProfileController.profile.value = loginScreenController.checkData[0]["profile_img"] ?? "";
              updateProfileController.name.text = loginScreenController.checkData[0]["name"] ?? "";
              final surname = loginScreenController.checkData[0]["surname"];
              updateProfileController.dateOfBirth.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(loginScreenController.checkData[0]["dob"]));
              updateProfileController.number.text = loginScreenController.checkData[0]["mobile_no"] ?? "";
              updateProfileController.email.text = loginScreenController.checkData[0]["email"] ?? "";
              updateProfileController.bloodGroup.text = loginScreenController.checkData[0]["blood_group"] ?? "";
              updateProfileController.profession.setDropDown(
                  DropDownValueModel(
                      name: loginScreenController.checkData[0]["profession"],
                      value: loginScreenController.checkData[0]["profession"]
                  ));
              updateProfileController.lastName.setDropDown(
                DropDownValueModel(
                  name: surname.toString(),
                  value: surname,
                ),
              );
              loginScreenController.checkData[0]["gender"] == "m" ? appRadioButtonController.selectedIndexGender.value = 0 : appRadioButtonController.selectedIndexGender.value = 1;
              loginScreenController.checkData[0]["husband_wife_of"] != null ? appRadioButtonController.selectedIndexMarital.value = 1 : appRadioButtonController.selectedIndexMarital.value = 0;
              updateProfileController.businessEmail.text = loginScreenController.checkData[0]["email"] ?? "";
              updateProfileController.businessNumber.text = loginScreenController.checkData[0]["mobile_no"] ?? "";
              updateProfileController.subProfession.text = loginScreenController.checkData[0]["sub_profession"] ?? "";
              updateProfileController.businessAddress.text = loginScreenController.checkData[0]["business_address"] ?? "";
              Get.to(UpdateProfile(memberId: loginScreenController.checkData[0]["id"],), transition: Transition.fadeIn, duration: Duration(milliseconds: 100),);
            },

            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: appColors.selectedColor.value,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.string(AppSvgs.edit1,color: AppColors.white,),
            ),
          ),
          SizedBox(width: 16,)
        ],
      ),
      body: Obx(() {
        if(loginScreenController.get.value){
          return Center(child: CircularProgressIndicator());
        }
        else{
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Obx(() =>   Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image:
                          loginScreenController.checkData[0]["profile_img"].toString().isEmpty || loginScreenController.checkData[0]["profile_img"] == null || loginScreenController.checkData[0]["profile_img"] == ""
                              ?AssetImage("assets/images/no-image.png")
                              :NetworkImage(loginScreenController.checkData[0]["profile_img"] ?? ""),
                              fit: BoxFit.contain
                          )
                      ),
                    ),
                  ),),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(AppSvgs.user),
                      Text("${loginScreenController.checkData[0]["name"]} ${loginScreenController.checkData[0]["surname"]}",style: Theme.of(context).textTheme.bodyBold,)
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(AppSvgs.locationPin),
                      Text("${loginScreenController.checkData[0]["family_house_id"]?["country"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["city"]??""}",style: Theme.of(context).textTheme.body1Regular,)
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      _callNumber(loginScreenController.checkData[0]["mobile_no"]);
                    },
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(AppSvgs.phone),
                        Text(loginScreenController.checkData[0]["mobile_no"],style: Theme.of(context).textTheme.body1Regular,)
                      ],
                    ),
                  ),
                  // Text("Lorem ipsum dolor sit amet consectetur. Id cursus sed ornare neque felis quam id.",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text,),textAlign: TextAlign.center,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap : (){
                            Get.to(MyFeed(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                          },
                          child: Column(
                            children: [
                              Text(
                                loginScreenController.checkData[0]["total_posts"],
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
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Get.to(ProfileBookMark(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                          },
                          child: Column(
                            children: [
                              Text(
                                loginScreenController.checkData[0]["total_bookmarks"],
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
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Get.to(LikePost(),transition: Transition.fadeIn,duration: Duration(milliseconds: 300));
                          },
                          child: Column(
                            children: [
                              Text(
                                loginScreenController.checkData[0]["total_liked_posts"],
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
                      ),
                    ],
                  ),
                  Text("Relations",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  /// relation Pending
                  Text("relation Pending",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),

                  Text("Full Family Name",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  Text("Charlotte Martin",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),

                  Text("Profession",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  Text(loginScreenController.checkData[0]["profession"]??"",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Marital Status",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                          Text(loginScreenController.checkData[0]["husband_wife_of"] == null ? "Unmarried" : "Married",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        ],
                      ),
                      Spacer(),
                      Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date of Birth",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                          Text(DateFormat("dd-MM-yyyy").format(DateTime.parse(loginScreenController.checkData[0]["dob"]??"")),style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                        ],
                      ),
                      Spacer()
                    ],
                  ),
                  Text("Permanent Location",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  Text("${loginScreenController.checkData[0]["family_house_id"]?["address"] ?? "" }, ${loginScreenController.checkData[0]["family_house_id"]?["city"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["state"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["country"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["pincode"]??""}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),

                  Text("Resident Location",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                  Text("${loginScreenController.checkData[0]["family_house_id"]?["address"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["city"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["state"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["country"]??""}, ${loginScreenController.checkData[0]["family_house_id"]?["pincode"]??""}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                ],
              ),
            ),
          );
        }
      })
    );
  }
}
