import 'dart:convert';

import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';
class ContactsController extends GetxController{

  TextEditingController search = TextEditingController();

  RxBool get = false.obs;
  RxList<Map<String,dynamic>> listOfMember = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfMemberAll = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfMemberDetails = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfMemberAllSearch = <Map<String,dynamic>>[].obs;

  ScrollController scrollController = ScrollController();

  int page = 0;
  int limit = 8;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  Future<void> mainMemberAll(String memberId) async{
    try{
      get.value = true;

      Map<String, String> queryParams = {};

      if (memberId.isNotEmpty) {
        queryParams["m"] = ApiUrl.membersList;
        queryParams["member_id"] = memberId;
      }
      else{
        queryParams["m"] = ApiUrl.membersList;
      }

      final url =  Uri.parse("${ApiUrl.baseUrl}").replace(queryParameters: queryParams);

      print("url ${url}");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("mainMemberAll");
          listOfMemberAll.clear();
          listOfMemberAll.value = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfMemberAllSearch.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print main member All Member${listOfMemberAll}");
          print("member id ${memberId}");
          print("member name ${listOfMemberAll[0]["name"]}");
        }
        else{
          get.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }

    }
    catch(error){
      get.value = false;
      print("error ${error}");
    }
    finally{
      get.value = false;
    }
  }
  Future<void> loadMainMemberAll(String memberId) async{
    try{
      get.value = true;

      Map<String, String> queryParams = {};

      if (memberId.isNotEmpty) {
        queryParams["m"] = ApiUrl.membersList;
        queryParams["member_id"] = memberId;
      }
      else{
        queryParams["m"] = ApiUrl.membersList;
      }

      final url =  Uri.parse("${ApiUrl.baseUrl}").replace(queryParameters: queryParams);

      print("url ${url}");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("mainMemberAll");
          listOfMemberAll.clear();
          listOfMemberAll.value = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfMemberAllSearch.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print main member All Member${listOfMemberAll}");
          print("member id ${memberId}");
          print("member name ${listOfMemberAll[0]["name"]}");
        }
        else{
          get.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }

    }
    catch(error){
      get.value = false;
      print("error ${error}");
    }
    finally{
      get.value = false;
    }
  }

  Future<void> mainMemberDetails(String memberId) async{
    try{
      get.value = true;

      Map<String, String> queryParams = {};

      if (memberId.isNotEmpty) {
        queryParams["m"] = ApiUrl.membersList;
        queryParams["member_id"] = memberId;
      }
      else{
        queryParams["m"] = ApiUrl.membersList;
      }

      final url =  Uri.parse("${ApiUrl.baseUrl}").replace(queryParameters: queryParams);

      print("url ${url}");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("mainMemberAll");
          listOfMemberDetails.clear();
          listOfMemberDetails.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print main member All Member${listOfMemberDetails}");
          print("member id ${memberId}");
          print("member name ${listOfMemberDetails}");
          get.value = false;
        }
        else{
          get.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }

    }
    catch(error){
      get.value = false;
      print("error ${error}");
    }
    finally{
      get.value = false;
    }
  }



  void runFilter(String keyword) {
    if (keyword.isEmpty) {
      listOfMemberAll.value =
      List<Map<String, dynamic>>.from(listOfMemberAllSearch);
    } else {
      listOfMemberAll.value = listOfMemberAllSearch.where((member) {

        final name =
        "${member["name"] ?? ""} ${member["surname"] ?? ""}"
            .toLowerCase();

        final mobile =
        (member["mobile_no"] ?? "").toString().toLowerCase();

        final profession =
        (member["profession"] ?? "").toString().toLowerCase();

        final searchText = keyword.toLowerCase();

        return name.contains(searchText) ||
            mobile.contains(searchText) ||
            profession.contains(searchText);

      }).toList();
    }
  }

}