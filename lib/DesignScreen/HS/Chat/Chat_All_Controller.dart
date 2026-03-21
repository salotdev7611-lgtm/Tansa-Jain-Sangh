import 'dart:convert';

import 'package:family_app/Helpers/api_url.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatAllController extends GetxController{

  TextEditingController search = TextEditingController();

  RxList<Map<String,dynamic>> listOfChatUser = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfChatUserSearch = <Map<String,dynamic>>[].obs;

  RxBool get = false.obs;
  Future<void> getChatData(String? type) async {
    try{
      
      final response = await http.get(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.chatGet}&type=${type}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token
        }
      );
      print("URL ${ApiUrl.chatBaseUrl}${ApiUrl.chatGet}&type=${type}");
      print("response data ${response.body}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          get.value = true;
          listOfChatUser.value = [];
          print("success");
          listOfChatUser.value = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfChatUserSearch.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("listOfChatUser  chat ${listOfChatUser.value}");
          get.value = false;
        }
        else{
          get.value = false;
          print("failed");
        }
      }
      else{
        get.value = false;
        print("failed");
      }
    }
    catch(error){
      get.value = false;
      print(error);
    }
    finally{
      get.value = false;
    }
  }

  void runFilter(String keyword) {
    if (keyword.isEmpty) {
      listOfChatUser.value =
      List<Map<String, dynamic>>.from(listOfChatUserSearch);
    } else {
      listOfChatUser.value = listOfChatUserSearch.where((member) {

        final name =
        "${member["member_id"]?["name"] ?? ""} ${member["member_id"]?["surname"] ?? ""}"
            .toLowerCase();

        final group = (member["group_id"]?["name"] ?? "").toString().toLowerCase();

        final searchText = keyword.toLowerCase();

        return name.contains(searchText) ||
            group.contains(searchText);

      }).toList();
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
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      // Format as date if older than a week
      return '${pastTime.day.toString().padLeft(2, '0')}-${pastTime.month.toString().padLeft(2, '0')}-${pastTime.year}';
    }
  }

}