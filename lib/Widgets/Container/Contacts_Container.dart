import 'package:family_app/DesignScreen/HS/Chat/Chat_Screen.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsContainer extends StatefulWidget {
  const ContactsContainer({super.key, required this.profileImage, required this.name, required this.profession, required this.familyName, required this.contactNo, required this.callIcon, required this.onTapCall, required this.chatIcon, required this.onTapChat, this.blockIcon, this.editIcon, required this.onTapEditScreen});
  final String profileImage;
  final String name;
  final String profession;
  final String familyName;
  final String contactNo;
  final String callIcon;
  final String chatIcon;
  final String? blockIcon;
  final String? editIcon;
  final VoidCallback onTapCall;
  final VoidCallback onTapChat;
  final VoidCallback onTapEditScreen;


  @override
  State<ContactsContainer> createState() => _ContactsContainerState();
}

class _ContactsContainerState extends State<ContactsContainer> {

  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: appColors.selectedColor.value.withValues(alpha: 0.3),
                offset: const Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(widget.profileImage)

                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),overflow: TextOverflow.ellipsis,),
                        Text(widget.profession,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),overflow: TextOverflow.ellipsis,),
                        Text(widget.familyName,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),overflow: TextOverflow.ellipsis,),
                        Text(widget.contactNo,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.grey),),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                spacing: 5,
                children: [

                  //  loginScreenController.addVidhi.value == true
                  //                       ? GestureDetector(
                  //                     child: Container(
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         color: appColors.selectedColor.value.withValues(alpha: 0.2),
                  //                       ),
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(6.0),
                  //                         child: widget.blockIcon != null
                  //                             ? SvgPicture.string(
                  //                           widget.blockIcon!,
                  //                           height: 20,
                  //                           width: 20,
                  //                         )
                  //                             : const SizedBox(
                  //                           height: 16,
                  //                           width: 16,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   )
                  //                       :

                  widget.contactNo == null || widget.contactNo == ""
                  ? SizedBox()
                  :GestureDetector(
                    onTap: widget.onTapChat,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.selectedColor.value.withValues(alpha: 0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.string(widget.chatIcon,height: 16,width: 16,),
                      ),
                    ),
                  ),
                  //loginScreenController.addVidhi.value == true
                  //                       ? GestureDetector(
                  //                     onTap: widget.onTapEditScreen,
                  //                     child: Container(
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         color: appColors.selectedColor.value.withValues(alpha: 0.2),
                  //                       ),
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(6.0),
                  //                         child: widget.editIcon != null
                  //                             ? SvgPicture.string(
                  //                           widget.editIcon!,
                  //                           height: 20,
                  //                           width: 20,
                  //                         )
                  //                             : const SizedBox(
                  //                           height: 16,
                  //                           width: 16,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   )
                  //                       :
                  widget.contactNo == null || widget.contactNo == ""
                      ? SizedBox()
                      : GestureDetector(
                    onTap: widget.onTapCall,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.selectedColor.value.withValues(alpha: 0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.string(widget.callIcon,height: 16,width: 16,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
