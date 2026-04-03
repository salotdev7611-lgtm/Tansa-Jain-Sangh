import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';


class ExploreContactsController extends GetxController {

  TextEditingController search = TextEditingController();
  RxList<Map<String,dynamic>> listOfMember = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfMemberSearch = <Map<String,dynamic>>[].obs;
  RxBool getValue = false.obs;

  int page = 0;
  int limit = 8;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    mainMember("house_main_person");

    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200){
        if(!isLoadingMore.value && hasMoreData.value){
          print("asdasdasdasdasdasdas");
          loadMainMember("house_main_person");
        }
      }
    },);
  }

  Future<void> mainMember(String type) async{
    try{

      page = 0;
      hasMoreData.value = true;

      getValue.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=${type}&limit_row=$limit&currentPage=$page"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print("gfgfgfgf ${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=${type}&limit_row=$limit&currentPage=$page");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          listOfMember.clear();
          listOfMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfMemberSearch.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print main member${listOfMember}");
          if (listOfMember.length < limit) {
            // hasMoreData.value = false;
          }
        }
        else{
          getValue.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        getValue.value = false;
        print("status code ${response.statusCode}");
      }

    }
    catch(error){
      getValue.value = false;
      print("error ${error}");
    }
    finally{
      getValue.value = false;
    }
  }
  // Future<void> loadMainMember(String type) async{
  //   try{
  //
  //     print("loadMainMember");
  //     isLoadingMore.value = true;
  //     page++;
  //
  //     final response = await http.get(
  //       Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=${type}&limit_row=$limit&currentPage=$page"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "x-api-key": ApiUrl.xApikey,
  //         "Authorization": ApiUrl.token,
  //       },
  //     );
  //
  //     print("LOAD ${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=${type}&limit_row=$limit&currentPage=$page");
  //
  //     if(response.statusCode == 200){
  //       final responseData = jsonDecode(response.body);
  //       if(responseData["success"] == true){
  //         final List<Map<String, dynamic>> newData =
  //         List<Map<String, dynamic>>.from(responseData["data"]);
  //         if (newData.isEmpty == true) {
  //           hasMoreData.value = false;
  //         }
  //         else{
  //           listOfMember.addAll(newData);
  //           listOfMemberSearch.addAll(newData);
  //         }
  //       }
  //       else{
  //         getValue.value = false;
  //         print("error msg ${responseData["errorMsg"].toString()}");
  //       }
  //     }
  //     else{
  //       getValue.value = false;
  //       print("status code ${response.statusCode}");
  //     }
  //
  //   }
  //   catch(error){
  //     getValue.value = false;
  //     print("error ${error}");
  //   }
  //   finally{
  //     isLoadingMore.value = false;
  //   }
  // }
  Future<void> loadMainMember(String type) async {
    try {
      print("LOAD");
      isLoadingMore.value = true;

      page++;

      final response = await http.get(
        Uri.parse(
          "${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=$type&limit_row=$limit&currentPage=$page",
        ),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print("LOAD : ${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&type=$type&limit_row=$limit&currentPage=$page");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          final List<Map<String, dynamic>> newData =
          List<Map<String, dynamic>>.from(responseData["data"]);

          if (newData.isEmpty) {
            hasMoreData.value = false;
          } else {
            listOfMember.addAll(newData);
            listOfMemberSearch.addAll(newData);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }
  void runFilter(String keyword) {
    if (keyword.isEmpty) {
      listOfMember.value =
      List<Map<String, dynamic>>.from(listOfMemberSearch);
    } else {
      listOfMember.value = listOfMemberSearch.where((member) {

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