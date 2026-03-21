import 'dart:convert';
import 'dart:io';
import 'package:family_app/DesignScreen/HS/Chat/PdfView.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../../../Helpers/api_url.dart';
import 'dart:typed_data';
class ChatScreenController extends GetxController {


  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final TextEditingController messageController = TextEditingController();

  RxString fileName = "".obs;
  RxString filePath = "".obs;
  RxString fileExt = "".obs;
  RxString pdfMemberId = "".obs;
  RxString pdfGroupId = "".obs;

  Future<bool> sendMessage(String messageId ,String groupId) async {
    try{

      List<int> fileBytes = [];

      // ✅ If file selected
      if (filePath.value.isNotEmpty) {
        File file = File(filePath.value);
        Uint8List uint8list = await file.readAsBytes();
        fileBytes = uint8list.toList(); // 🔥 convert to List<int>
      }

      Map<String, dynamic> message = {
        "message": messageController.text.trim(),
      };
      if (fileBytes.isNotEmpty) {
        message["file"] = {
          "byte": fileBytes,
          "extension": fileExt.value,
        };
      }

      if (messageId.isEmpty) {
        message["messaged_group_id"] = groupId;
      } else {
        message["messaged_to"] = messageId;
      }


      print(" Send message data ${message}");
      print("${messageController.text.trim()}");
      print(messageId);
      print(groupId);

      final response = await http.post(
          Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.messages}"),
        headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(message),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("send this message successfully ");
          messageController.clear();
          getMessage(messageId, groupId);
        }
        else{
          print("error message ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      return false;
    }
  }

  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxString lastMsg = "".obs;

  Future<void> getMessage(String messageId, String groupId,) async {
    try {
      final Map<String, String> queryParams = {
        "m": "messages", // always required
      };

      if (messageId.isNotEmpty && groupId.isEmpty) {
        queryParams["messaged_to"] = messageId;
      } else if (groupId.isNotEmpty && messageId.isEmpty) {
        queryParams["messaged_group_id"] = groupId;
      } else {
        print("Both IDs provided or both empty");
      }

      print("messageId ${messageId}");
      final uri = Uri.parse(ApiUrl.chatBaseUrl).replace(queryParameters: queryParams);

      print("Final URL → $uri");

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          messages.value = [];
          print("Response Body → ${response.body}");
          for(var item in data["data"]){
            final senderId = item["messaged_by"]["id"];
            final myId = loginScreenController.userId.value;
            final bool isMe = senderId == myId;
            print("FROM: ${item["messaged_by"]["id"]}");
            print("ME: ${loginScreenController.userId.value}");
            print("isMe ${isMe}");
            messages.add({
              "text" : item["message"] ?? "",
              "isMe": isMe,
              "time":getTimeDifferenceAsString(item["datetime"]),
              "isRead": item["is_read"] ?? false,
              "profile_img" : isMe == false ? item["messaged_by"]["profile_img"] ?? "" : "",
              "name" : isMe == false ? "${item["messaged_by"]["name"]} ${item["messaged_by"]["surname"]}" ?? "" : "",
              "file" : item["file"] ?? "",
            });
          }
        } else {
          print("API error message → ${data["errorMsg"]}");
        }
      } else {
        print("HTTP Status Code → ${response.statusCode}");
      }
    } catch (e) {
      print("Exception → ${e.toString()}");
    }
  }

  RxList<ChatMessage> messageList = <ChatMessage>[].obs;


  Future<bool> readMessage(String memberId, String groupId) async {
    try {
      Map<String, dynamic> message = {
        "last_msg_dt": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      };

      if (memberId.isEmpty) {
        message["messaged_group_id"] = groupId;
      } else {
        message["messaged_by"] = memberId;
      }

      print("readMessage payload => $message");

      final response = await http.put(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.readMsg}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          /// ✅ Mark all my sent messages as READ
          for (var msg in messageList) {
            if (msg.isMe && !msg.isRead) {
              msg.isRead = true;
            }
          }

          messageList.refresh();
          print("Messages marked as read");
        } else {
          print("API Error: ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }

      return false;
    } catch (error) {
      print(" Exception: $error");
      return false;
    }
  }

  Future<void> filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: [
        'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt',
      ],
    );
    if(result != null){
      XFile file = result.files.first.xFile;

      fileName.value = file.name;
      filePath.value = file.path;
      fileExt.value = file.name.split('.').last.toString();
      print('File name: ${file.name}');
      print('File path: ${file.path}');
      Get.to(Pdfview(filePath: filePath.value, fileName: fileName.value,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100))?.
      then((value) {
        fileName.value = "";
        filePath.value = "";
        fileExt.value = "";
        messageController.clear();
      },);
    }
    else{
      print("No file selected");
    }
  }

  String getTimeDifferenceAsString(String pastDateTimeStr) {
    // Parse the input string into DateTime
    DateTime pastTime = DateTime.parse("${pastDateTimeStr}Z").toLocal();
    DateTime localTime = DateTime.parse(pastDateTimeStr);
    print("PAST TIME : ${pastTime}");
    print("LOCAL TIME : ${localTime}");
    DateTime now = DateTime.now();

    Duration diff = now.difference(pastTime);
    print("DIFF TIME : ${diff}");

    if (diff.inSeconds < 60) {
      return 'Just Now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      // Format as date if older than a week
      return '${pastTime.year}-${pastTime.month.toString().padLeft(2, '0')}-${pastTime.day.toString().padLeft(2, '0')}';
    }
  }


}

  class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  bool isRead;

  ChatMessage({
  required this.id,
  required this.text,
  required this.isMe,
  required this.time,
  this.isRead = false,
  });
  }
