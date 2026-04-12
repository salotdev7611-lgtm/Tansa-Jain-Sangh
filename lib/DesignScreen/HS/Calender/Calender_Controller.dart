import 'dart:convert';

import 'package:family_app/DesignScreen/HS/Calender/Calender_Post_Model.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class CalenderController extends GetxController {

  RxBool isLoading = false.obs;
  var calenderModel = CalenderPostModel().obs;
  RxList<Map<String,dynamic>> listOfDate = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> dayDate= <Map<String,dynamic>>[].obs;

  Future<void> getCalender({required String month,required String year}) async {
    try{
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.gujaratiCalendar}&month=$month$year"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

      print("Calender URL Fetch ${ApiUrl.adminBaseUrl}${ApiUrl.gujaratiCalendar}&month=$month$year");

      if(response.statusCode == 200){
        calenderModel.value = CalenderPostModel.fromJson(jsonDecode(response.body));
        print("calenderModel ${calenderModel.value.data?.length}");
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          listOfDate.addAll(  List<Map<String, dynamic>>.from(responseData["data"]));
          print("object");
          print(listOfDate.value);
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
    }
    catch(error){
      print("error catch ${error}");
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> dayCalender({required date}) async {
    try{

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.gujaratiCalendar}&date=${date}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        }
      );

      print("tsp ${ApiUrl.baseUrl}${ApiUrl.gujaratiCalendar}&date=${date}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          dayDate.addAll(  List<Map<String, dynamic>>.from(responseData["data"]));
          print("object day date");
          print(dayDate.value);
        }
        else{
          print("error problem ${responseData["errorMsg"]}");
        }
      }
      else{
        print("error statusCode ${response.statusCode}");
      }
    }
    catch(error){
      print("error catch ${error}");
    }
  }
}