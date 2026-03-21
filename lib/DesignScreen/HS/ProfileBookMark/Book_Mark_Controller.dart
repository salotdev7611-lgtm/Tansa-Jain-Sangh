import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';

class BookMarkController extends GetxController {

  RxList<Map<String,dynamic>> listOfBookMark = <Map<String,dynamic>>[].obs;
  RxBool get = false.obs;

  Future<void> getProfileBookMark() async {

    try{

      get.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.profileBookmark}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          listOfBookMark.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("LIST OF BOOK MARK ${listOfBookMark.value}");
          get.value = false;
        }
        else{
          get.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      print("Error ${error}");
    }
    finally{
      get.value = false;
    }
  }
}