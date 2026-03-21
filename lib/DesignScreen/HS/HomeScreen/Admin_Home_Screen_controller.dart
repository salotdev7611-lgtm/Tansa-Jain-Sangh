import 'dart:convert';

import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/postModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AdminHomeScreenController extends GetxController{

  GlobalKey<FormState> postKey = GlobalKey();
  RxList<bool> saveListData = <bool>[].obs;
  RxList<bool> likeData = <bool>[].obs;

  RxList<int> likeCountData = <int>[].obs;


  RxInt selectIndex = (-1).obs;
  RxInt selectIndexPost = 0.obs;
  RxBool editDelete = false.obs;
  RxBool send = false.obs;
  // RxList<bool> editDeleteList = List.generate(10, (_) => false).obs;
  TextEditingController post = TextEditingController();
  TextEditingController comment = TextEditingController();

  RxBool add = false.obs;
  RxBool edit = false.obs;
  RxBool delete = false.obs;
  RxBool get = false.obs;
  RxBool likes = false.obs;
  RxBool save = false.obs;

  RxString userName = "".obs;
  RxString userId = "".obs;
  RxString profile = "".obs;
  RxString commentId = "".obs;
  RxString postString = "".obs;

  int page = 0;
  int limit = 5;

  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getPost(typeMsg: "admin-notification");

    scrollController.addListener((){
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200){
        if(!isLoadingMore.value && hasMoreData.value){
          if(selectIndexPost.value == 0){
            print("object ${selectIndexPost.value}");
            loadMorePost(typeMsg: 'admin-notification');
          }
          else if (selectIndexPost.value == 1){
            print("object ${selectIndexPost.value}");
            loadMorePost(typeMsg: 'bookmarked-profile');
          }
          else if(selectIndexPost.value == 2){
            print("object ${selectIndexPost.value}");
            loadMorePost(typeMsg: '');
          }
        }
      }
    });
  }

  RxList<Map<String,dynamic>> listOfPost = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfComments = <Map<String,dynamic>>[].obs;

  ///add post
  Future<bool> addPost() async{
    try{
      add.value = true;
      Map<String,dynamic> postAdd = {
        "content" : post.text.trim(),
      };
      print("POST ADD ${postAdd}");
      final response = await http.post(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(postAdd)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----- post send ----");
          getPost(typeMsg: "");
          selectIndexPost.value == 2;
          add.value = false;
          Get.back();
          return true;
        }
        else{
          add.value = false;
          print("error problem ${responseData["errorMsg"]}");
          return false;
        }
      }
      else{
        add.value = false;
        print("error problem ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      add.value = false;
      print("error problem ${error}");
      return false;
    }
    finally{
      add.value = false;
    }
  }

  var postModel = PostModel().obs;
  ///edit post
  Future<bool> editPost({required String id}) async {
    try{
      edit.value = true;

      Map<String,dynamic> postEdit = {
        "post_id" : id,
        "content" : post.text.trim(),
      };

      final response = await http.put(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(postEdit)
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          edit.value = false;
          Get.back();
          Get.back();
          getPost(typeMsg: "admin-notification");
          return true;
        }
        else{
          edit.value = false;
          print("error problem ${responseData["errorMsg"]}");
          return false;
        }
      }
      else{
        edit.value = false;
        print("error problem ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      edit.value = false;
      print("error problem ${error}");
      return false;
    }
    finally{
      edit.value = false;
    }
  }

  ///delete post
  Future<bool> deletePost({required String id}) async {
    try{

      delete.value = true;

      Map<String,dynamic> deletePost = {
        "post_id" : id,
      };

      final response = await http.delete(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(deletePost)
      );

      print("deletePost ${deletePost}");
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          print("---- delete success ----");
          delete.value = false;
          Get.back();
          Get.back();
          Get.back();
          getPost(typeMsg: "");
        }
        else{
          delete.value = false;
          print("error problem djhfjdhf ${responseData["errorMsg"]}");
          return false;
        }
      }
      else{
        delete.value = false;
        print("error problem ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      return false;
    }
  }

  ///get post
  Future<void> getPost({required String typeMsg}) async {
    try {

      page = 0;
      hasMoreData.value = true;

      get.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}&type=$typeMsg&limit_row=$limit&currentPage=$page"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print(" post ${ApiUrl.baseUrl}${ApiUrl.post}&type=$typeMsg&limit_row=$limit&currentPage=$page");


      if (response.statusCode == 200) {
        postModel.value = PostModel.fromJson(jsonDecode(response.body));
        print("post post ${postModel.value.data?.length}");
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {

          List<Map<String,dynamic>> data = List<Map<String,dynamic>>.from(responseData["data"]);

          listOfPost.clear();
          listOfPost.addAll(data);

          likeData.assignAll(
            data.map((p) => p["has_liked"] == true).toList(),
          );

          saveListData.assignAll(
            data.map((p) => p["has_bookmarked"] == true).toList(),
          );

          likeCountData.assignAll(
            data.map((p) => int.parse(p["likes"].toString())).toList(),
          );

          if (data.length < limit) {
            // hasMoreData.value = false;
          }
        }
      }

    } catch (error) {
      print(error);
    } finally {
      get.value = false;
    }
  }
  Future<void> loadMorePost({required String typeMsg}) async {
    try {
      debugPrint("load more post");
      debugPrint("load more post");

      isLoadingMore.value = true;
      page++;

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.post}&type=$typeMsg&limit_row=$limit&currentPage=$page"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print(" Load ${ApiUrl.baseUrl}${ApiUrl.post}&type=$typeMsg&limit_row=$limit&currentPage=$page ");

      if (response.statusCode == 200) {
        var temp  = PostModel.fromJson(jsonDecode(response.body));
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {

          debugPrint("TEMP : ${temp.data?.length}");
          List<Map<String,dynamic>> data = List<Map<String,dynamic>>.from(responseData["data"]);

          if (temp.data?.isEmpty == true) {

            hasMoreData.value = false;
          }
          else {

            /// add posts
            postModel.value.data?.addAll(temp.data!);
            postModel.update((val) {},);
            debugPrint("TEMP FINAL: ${postModel.value.data?.length}");


            /// extend like status
            likeData.addAll(
              data.map((p) => p["has_liked"] == true).toList(),
            );

            /// extend bookmark status
            saveListData.addAll(
              data.map((p) => p["has_bookmarked"] == true).toList(),
            );

            /// extend like counts
            likeCountData.addAll(
              data.map((p) => int.parse(p["likes"].toString())).toList(),
            );
          }
        }
      }

    } catch (e) {
      print(e);
    } finally {
      isLoadingMore.value = false;
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
    bool newValue = !likeData[index];

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
          likeData[index] = newValue;

          if (newValue) {
            likeCountData[index]++;
          } else {
            likeCountData[index]--;
          }

          return true;
        }
      }
    } catch (e) {
      print("likePost error: $e");
    }

    return false;
  }

  ///bookmark
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