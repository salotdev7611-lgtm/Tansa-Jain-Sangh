import 'package:family_app/DesignScreen/HS/Calender/Calender_Post_Model.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CalenderController extends GetxController {

  RxBool isLoading = false.obs;
  var calenderModel = CalenderPostModel().obs;
  RxList<Map<String,dynamic>> listOfDate = <Map<String,dynamic>>[].obs;

  Future<void> getCalender() async {
    try{
      isLoading.value = true;

      final response = http.get(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.gujaratiCalendar}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

    }
    catch(error){
      print("error catch ${error}");
    }
    finally{
      isLoading.value = false;
    }
  }

}