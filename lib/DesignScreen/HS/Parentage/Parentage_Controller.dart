import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';

class ParentageController extends GetxController {

  RxList<Map<String , dynamic>> listOfFamily = <Map<String,dynamic>>[].obs;


  Future<void> getMember({required String memberId}) async {
    try{

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
          print("object");
          List<Map<String,dynamic>> data = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfFamily.assignAll(data);
          print("object ${listOfFamily.length}");
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error problem ${response.statusCode}");
      }
    }
    catch(error){
      print("error catch ${error}");
    }
  }

}