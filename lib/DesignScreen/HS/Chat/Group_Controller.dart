import 'dart:convert';
import 'dart:io';

import 'package:family_app/Helpers/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';


class GroupController extends GetxController{

  TextEditingController group = TextEditingController();
  TextEditingController search = TextEditingController();

  RxString groupImage = "".obs;

  RxList<Map<String, dynamic>> listOfMember = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listOfFilterMember = <Map<String, dynamic>>[].obs;

  RxList<String> memberId = <String>[].obs;

  RxBool get = false.obs;
  RxBool create = false.obs;


  ///get member
  Future<void> getMember() async {
    try{
      get.value = true;
      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&search_str=${search.text}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        }
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          get.value = false;
          listOfMember.clear();
          listOfMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("listOfMember group ${listOfMember.value}");
          listOfFilterMember.assignAll(listOfMember); // initial full list

        }
        else{
          get.value = false;
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        get.value = false;
        print("error problem ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("error problem ${error}");
    }
    finally{
      get.value = false;
    }
  }

  void filterMember(String query) {
    if (query.isEmpty) {
      listOfFilterMember.assignAll(listOfMember);
    } else {
      listOfFilterMember.assignAll(
        listOfMember.where((member) {
          final name = member["name"].toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }


  ///create group
  Future<bool> createGroup() async {
    try{
      create.value = true;

      Map<String,dynamic> imageFile(String path){
        if(path.isNotEmpty && File(path).existsSync()){
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte" : fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte" : [],
          "extension": path.split('.').last,
        };
      }

      Map<String,dynamic> chatGroup = {
        "name" : group.text.trim(),
        "profile_icon" : imageFile(groupImage.value),
        "admin_only":true,
        "members" : memberId.value,
      };

      print("chatGroup ${chatGroup}");

      final response = await http.post(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.groups}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(chatGroup)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          Get.back();
          Get.back();
          create.value = false;
          print(" success to crate the group");

        }
        else{
          create.value = false;
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        create.value = false;
        print("error problem ${response.statusCode}");
      }
    return false;
    }
    catch(error){
      create.value = false;
      return false;
    }
    finally{
      create.value = false;
    }
  }

  ///get


  Future<void> profileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        groupImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }


}