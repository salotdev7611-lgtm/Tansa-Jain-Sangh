import 'dart:convert';

import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';
class MemberGroupController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  RxString selectedMemberId = "".obs;
  RxString memberId = "".obs;
  RxList<Map<String,dynamic>> listOfMember = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfFilterMember = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfGroupMember = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfGroup = <Map<String,dynamic>>[].obs;

  RxList<Map<String, dynamic>> filteredMemberList = <Map<String, dynamic>>[].obs;



  RxBool deleteIcons = false.obs;
  RxBool addButton = false.obs;
  RxBool get = false.obs;
  RxString createdBy = "".obs;

  ///get all member
  Future<void> getMember() async {
    try{
      get.value = true;
      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
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

          // listOfGroupMember.removeWhere((member) =>
          // member["id"].toString() == loginScreenController.userId.value.toString()
          // );
          //
          // listOfFilterMember.assignAll(listOfGroupMember);
          //
          // print("list filter to slow the member ${listOfFilterMember.value}");
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

  ///add member
  Future<bool> addMember({required String groupId,required String memberId}) async {
    try{

      Map<String,dynamic> member = {
        "group_id" : groupId,
        "member_id" : memberId,
      };

      print("add member in group ${member}");

      final response = await http.post(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.groupMember}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(member),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          print("------ add member in group ----------");
          getGroupMember(groupId);
          Get.back();
        }
        else{
          print("error msg ${responseData["errorMsg"]}");
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

  ///get group member
  Future<void> getGroupMember(String groupId) async{
    try{

      get.value = true;
      final response = await http.get(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.groupMember}&group_id=${groupId}"),
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
          listOfGroupMember.clear();
          listOfGroupMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("listOfGroupMember ${listOfGroupMember.value}");

        }
        else{
          get.value = false;
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        get.value = false;
        print("error status Code ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("error  ${error}");
    }
    finally{
      get.value = false;
    }
  }

  ///delete member
  Future<bool> deleteMember(String groupId,String memberId) async {
    try{

      Map<String,dynamic> member = {
        "group_id" : groupId,
        "member_id": memberId,
      };

      print("delete member in group ${member}");

      final response = await http.delete(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.groupMember}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token
        },
        body: jsonEncode(member),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("delete member");
          getGroupMember(groupId);
        }
        else{
          print("error msg ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error){



      print(error);
      return false;
    }
  }

  ///delete group
  Future<bool> deleteGroup(String groupId) async {
    try{

      Map<String,dynamic> group = {
        "group_id" : groupId,
      };
      
      print("delete group ${group}");


      final response = await http.delete(
        Uri.parse("${ApiUrl.chatBaseUrl}${ApiUrl.groups}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token
        },
        body: jsonEncode(group),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("delete group");
          Get.back();
          Get.back();
          return true;
        }
        else{
          print("error msg ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
      return false;
    }
    catch(error) {
      print(error);
      return false;
    }
  }


  void filterMembers() {
    final groupIds = listOfGroupMember.map((m) => m["id"].toString()).toSet();

    listOfFilterMember.value = listOfMember.where((member) {
      return !groupIds.contains(member["id"].toString());
    }).toList();
  }




}