import 'package:family_app/DesignScreen/HS/ContactsDetails/Add_Member.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/ContactsDetails.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/UpdateProfile/Update_Profile.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/Container/Contacts_Container.dart';
import 'package:family_app/Widgets/TextFormFields/app_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Chat/Chat_Screen.dart';

class Contacts extends StatefulWidget {

  const Contacts({super.key, required this.automaticallyImplyLeading, required this.isFormConnect,});

  final bool automaticallyImplyLeading;
  final bool isFormConnect;
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  final ContactsController contactsController = Get.put(ContactsController());

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
    print("kdhfksdhfksdhfksdfjhskdjfhskdfhksdhfksf ${loginScreenController.addVidhi.value}");
    data();
  }

  void data() {
    if( widget.isFormConnect == false) {
      contactsController.mainMemberAll("");
    }
    else{
      contactsController.mainMember("house_main_person");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Text(widget.isFormConnect == false ? "Members" :"Explore Contacts",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
        // actions: [
        //   Visibility(
        //     visible: loginScreenController.addVidhi.value,
        //     child: SvgPicture.string(AppSvgs.treeUser),),
        //   SizedBox(width: 16,)
        // ],
      ),
      body: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSearchbar(controller: contactsController.search,onChange: contactsController.runFilter,),
          ),
          Obx(() =>   widget.isFormConnect == false
              ? Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contactsController.listOfMemberAll.length,
              itemBuilder: (context, index) {
                final member = contactsController.listOfMemberAll[index];
                return GestureDetector(
                    onTap: (){
                      FocusScope.of(context).nextFocus();
                      Get.to(ContactsDetails(
                        image: member["profile_img"] ?? "",
                        name: member["name"] ?? "",
                        country: member["family_house_id"]?["country"] ?? "",
                        city: member["family_house_id"]?["city"]?? "",
                        connectNo: member["mobile_no"] ?? "",
                        fullFamilyName: "${member["father"]["name"] ?? ""} ${member["father"]["surname"] ?? ""}",
                        profession: member["profession"] ?? "",
                        maritalStatus: member["husband_wife_of"] == null ? "unmarried" : "married",
                        dateOfBirth: member["dob"],
                        permanentLocation: 'jdf',
                        residentLocation: 'kfk',
                        id: member["id"],
                      ),
                          transition: Transition.fadeIn,duration: Duration(milliseconds: 100))?.then((value) {  contactsController.mainMemberAll("");
                            FocusScope.of(context).nextFocus();});
                      FocusScope.of(context).nextFocus();

                    },
                    child: ContactsContainer(
                      profileImage: (member["profile_img"] ?? "").toString(),
                      name: "${(member["name"] ?? "").toString()} ${(member["surname"] ?? "").toString()}".trim(),
                      profession: (member["profession"] ?? "").toString(),
                      familyName: "${(member["father"]?["name"] ?? "").toString()} ${(member["father"]?["surname"] ?? "").toString()}".trim(),
                      contactNo: (member["mobile_no"] ?? "").toString(),
                      callIcon: member["mobile_no"] == null ? "" : AppSvgs.phone,
                      chatIcon: member["mobile_no"] == null ? "" : AppSvgs.chat,
                      blockIcon: AppSvgs.blockedUser,
                      editIcon: AppSvgs.edit1,
                      onTapCall: () {
                        _callNumber((member["mobile_no"] ?? "").toString());
                      },
                      onTapChat: () {
                        Get.to(
                          ChatScreen(name: "${(member["name"] ?? "").toString()} ${(member["surname"] ?? "").toString()}",
                            profileImg: member["profile_img"] ?? "",
                            memberId: member["id"],
                            groupId: '',
                            createdBy: '',),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                      },
                      onTapEditScreen: () {
                        Get.to(
                          UpdateProfile(memberId: member["id"],),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                      },));
              },),
          )
              : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contactsController.listOfMember.length,
              itemBuilder: (context, index) {
                final member = contactsController.listOfMember[index];
                return GestureDetector(
                    onTap: (){
                      FocusScope.of(context).nextFocus();
                      Get.to(ContactsDetails(
                        image: member["profile_img"] ?? "",
                        name: member["name"] ?? "",
                        country: member["family_house_id"]?["country"] ?? "",
                        city: member["family_house_id"]?["city"]?? "",
                        connectNo: member["mobile_no"] ?? "",
                        fullFamilyName: "${member["father"]?["name"] ?? ""} ${member["father"]?["surname"] ?? ""}",
                        profession: member["profession"] ?? "",
                        maritalStatus: 'hrll',
                        dateOfBirth: 'jd',
                        permanentLocation: 'jdf',
                        residentLocation: 'kfk',
                        id: member['id'],
                      ),
                          transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                      FocusScope.of(context).nextFocus();

                    },
                    child: ContactsContainer(
                      profileImage: (member["profile_img"] ?? "").toString(),
                      name: "${(member["name"] ?? "").toString()} ${(member["surname"] ?? "").toString()}".trim(),
                      profession: (member["profession"] ?? "").toString(),
                      familyName: "${(member["father"]?["name"] ?? "").toString()} ${(member["father"]?["surname"] ?? "").toString()}".trim(),
                      contactNo: (member["mobile_no"] ?? "").toString(),
                      callIcon:  AppSvgs.phone,
                      chatIcon: AppSvgs.chat,
                      blockIcon: AppSvgs.blockedUser,
                      editIcon: AppSvgs.edit1,
                      onTapCall: () {
                        _callNumber((member["mobile_no"] ?? "").toString());
                      },
                      onTapChat: () {
                        Get.to(
                          ChatScreen(name: '', profileImg: '', memberId: '', groupId: '', createdBy: '',),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                      },
                      onTapEditScreen: () {
                        Get.to(
                          UpdateProfile(memberId: member["id"],),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 100),
                        );
                      },));
              },),
          ),)
        ],
      ),
      floatingActionButton: Visibility(
          visible: loginScreenController.addVidhi.value,
          child: ActiveIconButton(onTap: (){
            Get.to(AddMember(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          }, text: "Add Member", icon: AppSvgs.add)),
    );
  }
}
