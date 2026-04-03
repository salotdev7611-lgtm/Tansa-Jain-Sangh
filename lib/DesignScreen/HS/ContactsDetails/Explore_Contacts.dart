import 'package:family_app/DesignScreen/HS/ContactsDetails/Explore_Contacts_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Helpers/app_colors.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../TextTheme/text_theme.dart';
import '../../../Widgets/Buttons/active_icon_button.dart';
import '../../../Widgets/Container/Contacts_Container.dart';
import '../../../Widgets/TextFormFields/app_searchbar.dart';
import '../Chat/Chat_Screen.dart';
import '../UpdateProfile/Update_Profile.dart';
import 'Add_Member.dart';
import 'ContactsDetails.dart';


class ExploreContacts extends StatefulWidget {
  const ExploreContacts({super.key});

  @override
  State<ExploreContacts> createState() => _ExploreContactsState();
}

class _ExploreContactsState extends State<ExploreContacts> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final ExploreContactsController exploreContactsController = Get.put(ExploreContactsController());

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
    exploreContactsController.mainMember("house_main_person");
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
        title: Text("Explore Contacts",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSearchbar(controller: exploreContactsController.search,onChange: exploreContactsController.runFilter,),
          ),
          Obx(() {
            if(exploreContactsController.getValue.value){
              return ListView.builder(
                controller: exploreContactsController.scrollController,
                itemCount: 6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 20, backgroundColor: Colors.white),
                                SizedBox(width: 10),
                                Container(height: 10, width: 100, color: Colors.white),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 10, width: double.infinity, color: Colors.white),
                            SizedBox(height: 5),
                            Container(height: 10, width: double.infinity, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            else{
              return Expanded(
                child: ListView.builder(
                  controller: exploreContactsController.scrollController,
                  shrinkWrap: true,
                  itemCount: exploreContactsController.listOfMember.length,
                  itemBuilder: (context, index) {
                    if(index == exploreContactsController.listOfMember.length){
                      if(exploreContactsController.isLoadingMore.value){
                        return  Obx(() => Padding(
                          padding: const EdgeInsets.all(10),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(radius: 20, backgroundColor: Colors.white),
                                      SizedBox(width: 10),
                                      Container(height: 10, width: 100, color: Colors.white),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(height: 10, width: double.infinity, color: Colors.white),
                                  SizedBox(height: 5),
                                  Container(height: 10, width: double.infinity, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),);
                      }
                    }
                    final member = exploreContactsController.listOfMember[index];
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
              );
            }
          })
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
