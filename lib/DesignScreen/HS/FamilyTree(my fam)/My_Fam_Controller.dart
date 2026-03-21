import 'dart:convert';

import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyFamController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  RxList<Map<String,dynamic>> listOfMember = <Map<String,dynamic>>[].obs;
  RxBool get = false.obs;

  Future<void> getMember() async {
    try{

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&family_house_id=${loginScreenController.houseId.value}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        }
      );
      get.value = true;
      print("${ApiUrl.baseUrl}${ApiUrl.membersList}&family_house_id=${loginScreenController.houseId.value}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          listOfMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("MY FAM ${listOfMember.value}");
          get.value = false;
        }
        else{
          get.value = false;
          print("error msg ${responseData["errorMsg"]}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("catch error ${error}");
    }
    finally{
      get.value = false;
    }
  }

}