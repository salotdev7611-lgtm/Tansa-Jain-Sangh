// import 'dart:async';
// import 'package:family_app/DesignScreen/HS/Chat/Chat_Screen_Controller.dart';
// import 'package:family_app/DesignScreen/HS/Chat/Member_Group.dart';
// import 'package:family_app/DesignScreen/HS/Chat/PdfView.dart';
// import 'package:family_app/DesignScreen/HS/MyProfile/Profile.dart';
// import 'package:family_app/Helpers/app_colors.dart';
// import 'package:family_app/Helpers/app_svgs.dart';
// import 'package:family_app/TextTheme/text_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key, required this.name, required this.profileImg, required this.memberId, required this.groupId, required this.createdBy});
//
//   final String name;
//   final String profileImg;
//   final String memberId;
//   final String groupId;
//   final String createdBy;
//
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final AppColors appColors = Get.put(AppColors());
//   bool send = false;
//
//   final ChatScreenController chatScreenController = Get.put(ChatScreenController());
//   final ScrollController _scrollController = ScrollController();
//
//
//   Timer? _messageTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     chatScreenController.getMessage(widget.memberId, widget.groupId,);
//     chatScreenController.readMessage(widget.memberId, widget.groupId);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     });
//
//     chatScreenController.pdfGroupId.value = widget.groupId;
//     chatScreenController.pdfMemberId.value = widget.memberId;
//
//     _messageTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       chatScreenController.getMessage(widget.memberId, widget.groupId,);
//       chatScreenController.readMessage(widget.memberId, widget.groupId);
//     });
//   }
//   // void _scrollToBottom() {
//   //   print("FN CALLED");
//   //   if (!scrollController.hasClients) return;
//   //   print("FN CALLED 2");
//   //   scrollController.animateTo(
//   //     scrollController.position.maxScrollExtent + 100,
//   //     duration: const Duration(milliseconds: 300),
//   //     curve: Curves.easeOut,
//   //   );
//   //   print("FN CALLED 3");
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       backgroundColor: AppColors.white,
//
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         title: GestureDetector(
//           onTap: () {
//
//             print("wid ${widget.memberId}");
//             print("grp ${widget.groupId}");
//
//             widget.memberId.isNotEmpty
//                 ?  Get.to(Profile(
//               profileImg: widget.profileImg,
//               userName: widget.name,
//               country: '',
//               phoneNumber: '',
//               profession: '',
//               maritalStatus: '',
//               dateOfBirth: '',
//               permanentLocation: '',
//               residentLocation: '',),transition: Transition.fadeIn,duration: Duration(milliseconds: 100))
//                 : Get.to(MemberGroup(groupProfileImg: widget.profileImg, groupName: widget.name, groupId: widget.groupId, createdBy: widget.createdBy,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
//           },
//           child: Row(
//             children: [
//               Container(
//                 height: 40,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xff000000).withValues(alpha: 0.09),
//                       offset: const Offset(0, 0),
//                       blurRadius: 10,
//                       spreadRadius: 0,
//                     ),
//                   ],
//                   image: DecorationImage(
//                     image: (widget.profileImg != null &&
//                         widget.profileImg.toString().isNotEmpty)
//                         ? NetworkImage(widget.profileImg)
//                         : const AssetImage("assets/images/no-image.png")
//                     as ImageProvider,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               //  CircleAvatar(
//               //    backgroundColor: AppColors.white,
//               //   backgroundImage: NetworkImage(widget.profileImg),
//               // ),
//               const SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyBold
//                           .copyWith(color: AppColors.text)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Obx(() {
//
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//             });
//
//             return Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 itemCount: chatScreenController.messages.length,
//                 itemBuilder: (context, index) {
//                   final msg = chatScreenController.messages[index];
//                   return ChatBubble(
//                     message: msg["text"] ?? "",
//                     isMe: msg["isMe"] ?? false,
//                     time: msg["time"] ?? "",
//                     colors: appColors.selectedColor.value,
//                     isRead: msg["isRead"] ?? false,
//                     image: msg["profile_img"] ?? "",
//                     file: msg["file"] ?? "",
//                     name: msg["name"] ?? "",
//                   );
//                 },
//               ),
//             );},),
//           // Obx(() {
//           //   if (chatScreenController.fileName.value.isEmpty) {
//           //     return Center(child: Text("No file selected"));
//           //   }
//           //
//           //   IconData icon;
//           //
//           //   switch (chatScreenController.fileExt.value) {
//           //     case 'pdf':
//           //       icon = Icons.picture_as_pdf;
//           //       break;
//           //     case 'doc':
//           //     case 'docx':
//           //       icon = Icons.description;
//           //       break;
//           //     case 'xls':
//           //     case 'xlsx':
//           //       icon = Icons.table_chart;
//           //       break;
//           //     case 'ppt':
//           //     case 'pptx':
//           //       icon = Icons.slideshow;
//           //       break;
//           //     default:
//           //       icon = Icons.insert_drive_file;
//           //   }
//           //
//           //   return GestureDetector(
//           //     onTap: (){
//           //       Get.to(() => Pdfview(filePath: chatScreenController.filePath.value, fileName: chatScreenController.fileName.value,));
//           //     },
//           //     child: Container(
//           //       padding: EdgeInsets.all(12),
//           //       margin: EdgeInsets.all(10),
//           //       decoration: BoxDecoration(
//           //         border: Border.all(color: Colors.grey),
//           //         borderRadius: BorderRadius.circular(10),
//           //       ),
//           //       child: Row(
//           //         children: [
//           //           Icon(icon, size: 40, color: Colors.blue),
//           //           SizedBox(width: 10),
//           //           Expanded(
//           //             child: Text(
//           //               chatScreenController.fileName.value,
//           //               overflow: TextOverflow.ellipsis,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   );
//           // }),
//
//           /// INPUT FIELD + MIC
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
//                   child: Card(
//                     color: AppColors.white,
//                     elevation: 4,
//                     shadowColor: Colors.black12,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: TextFormField(
//                       onChanged: (value) {
//                         setState(() {
//                           send = value.isNotEmpty;
//                         });
//                       },
//                       controller: chatScreenController.messageController,
//                       decoration: InputDecoration(
//                         hintText: "Type a Message...",
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .body2Regular
//                             .copyWith(color: AppColors.text),
//                         filled: true,
//                         fillColor: AppColors.white,
//                         suffixIcon: GestureDetector(
//                             onTap: (){
//                               chatScreenController.filePicker();
//                             },
//                             child: Icon(Icons.attach_file_outlined)),
//
//                         // Border settings
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(50),
//                           borderSide: BorderSide(color: AppColors.grey, width: 1),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(50),
//                           borderSide: BorderSide(color: AppColors.grey, width: 1),
//                         ),
//
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               GestureDetector(
//                 onTap: () {
//                   final text = chatScreenController.messageController.text.trim();
//                   if (text.isEmpty) return;
//
//                   chatScreenController.messages.add({
//                     "text": text,
//                     "isMe": true,
//                     "time": DateFormat("hh:mm a").format(DateTime.now()),
//                   });
//
//                   chatScreenController.sendMessage(
//                     widget.memberId,
//                     widget.groupId,
//                   );
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: appColors.selectedColor.value
//                   ),
//                   child: Center(
//                     child: SizedBox(
//                         height: 30,
//                         width: 30,
//                         child: SvgPicture.string(AppSvgs.send)),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 12),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;
//   final String time;
//   final String image;
//   final Color colors;
//   final bool isRead;
//   final String file;
//   final String name;
//
//   const ChatBubble({
//     super.key,
//     required this.message,
//     required this.isMe,
//     required this.time,
//     required this.colors,
//     required this.isRead,
//     required this.image,
//     required this.file,
//     required this.name,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       spacing: 4,
//       mainAxisAlignment:
//       isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(vertical: 5),
//           padding: const EdgeInsets.all(12),
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.7,
//           ),
//           decoration: BoxDecoration(
//             color: isMe ? colors : AppColors.lightGrey,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               ///name
//               isMe ? SizedBox() :
//               Text(
//                 name,
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1Bold
//                     ?.copyWith(
//                   color: isMe ? Colors.yellowAccent : Colors.orangeAccent,
//                 ),
//               ),
//
//
//               file.isNotEmpty
//                   ? GestureDetector(
//                 onTap: () async {
//                   // open file
//                   print("open file");
//                   final Uri url = Uri.parse(file);
//                   if(await canLaunchUrl(url)){
//                     await launchUrl(url,mode: LaunchMode.externalApplication);
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   margin: EdgeInsets.only(bottom: 6),
//                   decoration: BoxDecoration(
//                     color: isMe ? Colors.white24 : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.picture_as_pdf,
//                         color: Colors.red,
//                         size: 20,
//                       ),
//                       SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           file.split('/').last,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: isMe ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//                   : SizedBox(),
//               Text(
//                 message,
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1Regular
//                     .copyWith(
//                   color: isMe ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     time,
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: isMe ? Colors.white70 : Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   if (isMe)
//                     Icon(
//                       isRead ? Icons.done_all : Icons.check,
//                       size: 16,
//                       color: isRead ? Colors.blue : Colors.white70,
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         image.isEmpty
//             ? SizedBox()
//             : Container(
//           height: 35,
//           width: 35,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(image: NetworkImage(image),
//               fit: BoxFit.contain,
//             ),
//             color: AppColors.white,
//           ),
//         )
//       ],
//     );
//   }
// }
import 'dart:async';
import 'package:family_app/DesignScreen/HS/Chat/Chat_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/Chat/Member_Group.dart';
import 'package:family_app/DesignScreen/HS/Chat/PdfView.dart';
import 'package:family_app/DesignScreen/HS/MyProfile/Profile.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ContactsDetails/ContactsDetails.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name, required this.profileImg, required this.memberId, required this.groupId, required this.createdBy});

  final String name;
  final String profileImg;
  final String memberId;
  final String groupId;
  final String createdBy;


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AppColors appColors = Get.put(AppColors());
  bool send = false;

  final ChatScreenController chatScreenController = Get.put(ChatScreenController());
  final ScrollController _scrollController = ScrollController();


  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    chatScreenController.getMessage(widget.memberId, widget.groupId,);
    chatScreenController.readMessage(widget.memberId, widget.groupId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    chatScreenController.pdfGroupId.value = widget.groupId;
    chatScreenController.pdfMemberId.value = widget.memberId;

    _messageTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      chatScreenController.getMessage(widget.memberId, widget.groupId,);
      chatScreenController.readMessage(widget.memberId, widget.groupId);
    });
  }
  // void _scrollToBottom() {
  //   print("FN CALLED");
  //   if (!scrollController.hasClients) return;
  //   print("FN CALLED 2");
  //   scrollController.animateTo(
  //     scrollController.position.maxScrollExtent + 100,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  //   print("FN CALLED 3");
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {

            print("wid ${widget.memberId}");
            print("grp ${widget.groupId}");

            widget.memberId.isNotEmpty
                ?  Get.to(ContactsDetails(
              country: '',
              profession: '',
              maritalStatus: '',
              dateOfBirth: '',
              permanentLocation: '',
              residentLocation: '',
              name: '',
              city: '',
              connectNo: '',
              fullFamilyName: '',
              image: '',
              id: widget.memberId,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100))
                : Get.to(MemberGroup(groupProfileImg: widget.profileImg, groupName: widget.name, groupId: widget.groupId, createdBy: widget.createdBy,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          },
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
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
                  image: DecorationImage(
                    image: (widget.profileImg != null &&
                        widget.profileImg.toString().isNotEmpty)
                        ? NetworkImage(widget.profileImg)
                        : const AssetImage("assets/images/no-image.png")
                    as ImageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              //  CircleAvatar(
              //    backgroundColor: AppColors.white,
              //   backgroundImage: NetworkImage(widget.profileImg),
              // ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyBold
                          .copyWith(color: AppColors.text)),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Obx(() {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            });

            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: chatScreenController.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatScreenController.messages[index];
                  return ChatBubble(
                    message: msg["text"] ?? "",
                    isMe: msg["isMe"] ?? false,
                    time: msg["time"] ?? "",
                    colors: appColors.selectedColor.value,
                    isRead: msg["isRead"] ?? false,
                    image: msg["profile_img"] ?? "",
                    file: msg["file"] ?? "",
                    name: msg["name"] ?? "",
                  );
                },
              ),
            );},),
          // Obx(() {
          //   if (chatScreenController.fileName.value.isEmpty) {
          //     return Center(child: Text("No file selected"));
          //   }
          //
          //   IconData icon;
          //
          //   switch (chatScreenController.fileExt.value) {
          //     case 'pdf':
          //       icon = Icons.picture_as_pdf;
          //       break;
          //     case 'doc':
          //     case 'docx':
          //       icon = Icons.description;
          //       break;
          //     case 'xls':
          //     case 'xlsx':
          //       icon = Icons.table_chart;
          //       break;
          //     case 'ppt':
          //     case 'pptx':
          //       icon = Icons.slideshow;
          //       break;
          //     default:
          //       icon = Icons.insert_drive_file;
          //   }
          //
          //   return GestureDetector(
          //     onTap: (){
          //       Get.to(() => Pdfview(filePath: chatScreenController.filePath.value, fileName: chatScreenController.fileName.value,));
          //     },
          //     child: Container(
          //       padding: EdgeInsets.all(12),
          //       margin: EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.grey),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(icon, size: 40, color: Colors.blue),
          //           SizedBox(width: 10),
          //           Expanded(
          //             child: Text(
          //               chatScreenController.fileName.value,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // }),

          /// INPUT FIELD + MIC
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                  child: Card(
                    color: AppColors.white,
                    elevation: 4,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          send = value.isNotEmpty;
                        });
                      },
                      controller: chatScreenController.messageController,
                      decoration: InputDecoration(
                        hintText: "Type a Message...",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .body2Regular
                            .copyWith(color: AppColors.text),
                        filled: true,
                        fillColor: AppColors.white,
                        suffixIcon: GestureDetector(
                            onTap: (){
                              chatScreenController.filePicker();
                            },
                            child: Icon(Icons.attach_file_outlined)),

                        // Border settings
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.grey, width: 1),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  final text = chatScreenController.messageController.text.trim();
                  if (text.isEmpty) return;

                  chatScreenController.messages.add({
                    "text": text,
                    "isMe": true,
                    "time": DateFormat("hh:mm a").format(DateTime.now()),
                  });

                  chatScreenController.sendMessage(
                    widget.memberId,
                    widget.groupId,
                  );
                  // chatScreenController.getMessage(widget.memberId,
                  //   widget.groupId,);

                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.selectedColor.value
                  ),
                  child: Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.string(AppSvgs.send)),
                  ),
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String image;
  final Color colors;
  final bool isRead;
  final String file;
  final String name;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
    required this.colors,
    required this.isRead,
    required this.image,
    required this.file,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      mainAxisAlignment:
      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isMe ? colors : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ///name
              isMe ? SizedBox() :
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .body1Bold
                    ?.copyWith(
                  color: isMe ? Colors.yellowAccent : Colors.orangeAccent,
                ),
              ),


              file.isNotEmpty
                  ? GestureDetector(
                onTap: () async {
                  // open file
                  print("open file");
                  final Uri url = Uri.parse(file);
                  if(await canLaunchUrl(url)){
                    await launchUrl(url,mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          file.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox(),
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .body1Regular
                    .copyWith(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (isMe)
                    Icon(
                      isRead ? Icons.done_all : Icons.check,
                      size: 16,
                      color: isRead ? Colors.blue : Colors.white70,
                    ),
                ],
              ),
            ],
          ),
        ),
        image.isEmpty
            ? SizedBox()
            : Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(image),
              fit: BoxFit.contain,
            ),
            color: AppColors.white,
          ),
        )
      ],
    );
  }
}
