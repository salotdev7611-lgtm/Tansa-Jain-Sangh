import 'dart:convert';

import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';
import '../HomeScreen/Admin_Home_Screen_controller.dart';

class LikePostController extends GetxController {

  final AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  RxList<Map<String,dynamic>> listOfLikePost = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfComments = <Map<String,dynamic>>[].obs;
  RxList<bool> saveList = <bool>[].obs;
  RxList<bool> like = <bool>[].obs;
  RxList<int> likeCount = <int>[].obs;
  RxInt selectIndex = (-1).obs;
  RxBool editDelete = false.obs;
  RxBool send = false.obs;
  RxBool add = false.obs;
  RxBool edit = false.obs;
  RxBool delete = false.obs;
  RxBool get = false.obs;

  RxString userName = "".obs;
  RxString commentId = "".obs;

  TextEditingController comment = TextEditingController();


  Future<void> getLikePost() async {
    try{
      print("1");
      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}&liked_by=${loginScreenController.userId.value}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

      print(ApiUrl.token);
      print("2");
      print("RESPONSE DATA like post${response.body}");
      print("RESPONSE DATA like url ${ApiUrl.baseUrl}${ApiUrl.post}&liked_by=${loginScreenController.userId.value}");

      if(response.statusCode == 200) {
        print("3");
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("4");

          listOfLikePost.value = List<Map<String,dynamic>>.from(responseData["data"]);
          // ✅ sync like state safely
          like.assignAll(
            listOfLikePost.map((p) => p["has_liked"] == true).toList(),
          );

         saveList.assignAll(
            listOfLikePost.map((p) => p["has_bookmarked"] == true).toList(),
          );

          likeCount.assignAll(
            listOfLikePost.map(
                  (p) => int.parse(p["likes"].toString()),
            ).toList(),
          );

          print("LIST OF LIKE POST ${listOfLikePost.value}");

        }
        else{
          print("5");
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      print("Error ${error}");
    }
  }

  ///add comment
  Future<bool> addComment(String postID) async {
    try{

      Map<String,dynamic> commentData = {
        "post_id" : postID,
        "comment" : comment.text.trim(),
      };

      print("comment map ${commentData}");
      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.postComments}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(commentData),
      );

      print("response data show in body ${response.body}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          print("---- comment success ----");
          Get.back();
          return true;
        }
        else {
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else {
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("error catch ${error}");
      return false;
    }
  }

  ///edit comment
  Future<bool> editComment(String commentId , String postId) async {
    try{

      Map<String,dynamic> commentEdit = {
        "comment_id" : commentId,
        "post_id" : postId,
        "comment" : comment.text.trim(),
      };

      print("commentEdit ${commentEdit}");

      final response = await http.put(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.postComments}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(commentEdit),
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          print("comment update successfully");
          Get.back();
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("error catch ${error}");
      return false;
    }
  }

  ///delete comment
  Future<bool> deleteComment(String commentId,String postId) async {
    try{

      Map<String,dynamic> commentDelete = {
        "post_id" : postId,
        "comment_id" : commentId,
      };
      print("commentDelete ${commentDelete}");

      final response = await http.delete(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.postComments}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(commentDelete),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          print("delete comment");
          Get.back();
          Get.back();
          Get.back();
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("error catch ${error}");
      return false;
    }
  }

  ///get comments
  Future<void> postComments(String postID) async {
    try{
      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.postComments}&post_id=${postID}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          }
      );

      if(response.statusCode == 200){
        get.value = true;
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("get comments");
          get.value = false;
          listOfComments.clear();
          listOfComments.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("list of comments data ${listOfComments.value}");

        }
        else{
          get.value = false;
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        get.value = false;
        print("error statusCode ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("error catch ${error}");
    }
    finally{
      get.value = false;
    }
  }

  ///like
  Future<bool> likePost(String postId, int index) async {
    bool newValue = !like[index];

    try {
      Map<String, dynamic> body = {
        "post_id": postId,
        "liked": newValue,
      };

      final response = await http.put(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.like}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          like[index] = newValue;

          if (newValue) {
            likeCount[index]++;
          } else {
            likeCount[index]--;
          }

          return true;
        }
      }
    } catch (e) {
      print("likePost error: $e");
    }

    return false;
  }

  Future<bool> profileBookmark(String personId) async {
    try{

      Map<String,dynamic> bookMark = {
        "bookmark_to" : personId,
      };

      print("bookMark :  ${bookMark}");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.profileBookmark}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(bookMark),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("bookmark success");
          return true;
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
          return false;
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      print("error catch ${error}");
      return false;
    }
  }

  Future<bool> profileBookmarkDelete(String personId) async{
    try{
      Map<String,dynamic> bookMark = {
        "bookmark_to" : personId,
      };

      print("bookMark :  ${bookMark}");

      final response = await http.delete(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.profileBookmark}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(bookMark),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("bookmark delete success");
          return true;
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
          return false;
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      print("error catch ${error}");
      return false;
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