import 'dart:io';
import 'dart:convert';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../../TextTheme/text_theme.dart';

class AddEventController extends GetxController{

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AppColors appColors = Get.put(AppColors());

  GlobalKey<FormState> eventKey = GlobalKey();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController startMin = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController endMin = TextEditingController();
  TextEditingController organizerName = TextEditingController();
  TextEditingController eventName = TextEditingController();
  TextEditingController liveLink = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  RxBool isAmSelected = true.obs;
  RxBool isPmSelected = true.obs;
  RxBool updateEvent = false.obs;

  RxList<Map<String,dynamic>> listOfEvent = <Map<String,dynamic>>[].obs;

  RxString event = "".obs;
  RxBool add = false.obs;
  RxBool edit = false.obs;
  RxBool delete = false.obs;
  RxBool get = false.obs;

  ///add event
  Future<bool> eventAdd(context) async {

  try{
    add.value = true;

    Map<String,dynamic> file(String path){
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
    ///start date convert
    final DateTime parseDate =DateFormat("dd-MM-yyyy").parse(startDate.text.trim());
    final String apiDate = DateFormat("yyyy-MM-dd").format(parseDate);

    ///end date convert
    final DateTime parseEndDate =DateFormat("dd-MM-yyyy").parse(endDate.text.trim());
    final String apiEndDate = DateFormat("yyyy-MM-dd").format(parseEndDate);


    ///24 hours convert
    int startH = int.parse(startTime.text.trim());
    int startM = int.parse(startMin.text.trim());

    if(isAmSelected.value){
      if(startH == 12) startH = 0;
    }
    else{
      if(startH != 12) startH += 12;
    }
    final String apiTime =  "${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}";

    int endH = int.parse(endTime.text.trim());
    int endM = int.parse(endMin.text.trim());

    if(isPmSelected.value == false){
      if(endH != 12) endH += 12;
      // if(endH == 12) endH = 0;
    }
    else{
      if(endH == 12) endH = 0;
    }
    final String apiEndTime =
        "${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}";

    Map<String,dynamic> eventMap = {
      "title" : eventName.text.trim(),
      "description" : description.text.trim(),
      "img" : file(event.value),
      "location" : location.text.trim(),
      // "address" : "hrllo",
      "start_datetime" : "${apiDate} ${apiTime}:00",
      "end_datetime" : "${apiEndDate} ${apiEndTime}:59",
      "live_url" : liveLink.text.trim(),
    };

    print("Event Map ${eventMap}");
    print("${startTime.text.trim()} ${startMin.text.trim()} ${isAmSelected.value == true ? "AM" : "PM"}");
    print("${apiEndDate} ${apiEndTime}:59 ${isPmSelected.value == true ? "PM" : "AM"}");

    final response = await http.post(
      Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.event}"),
      headers: {
        "Content-Type" : "Application/json",
        "x-api-key" : ApiUrl.xApikey,
        "Authorization" : ApiUrl.token,
      },
        body: jsonEncode(eventMap)
    );

    if(response.statusCode == 200){
      final responseData = jsonDecode(response.body);
      if(responseData["success"] == true){
        event.value = "";
        eventName.clear();
        location.clear();
        description.clear();
        startDate.clear();
        endDate.clear();
        startTime.clear();
        startMin.clear();
        endTime.clear();
        endMin.clear();
        liveLink.clear();
        add.value = false;
        ///success
        print("success event add");
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                width: Get.width,
                content: Container(
                    decoration: BoxDecoration(
                      color: appColors.selectedColor.value,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Text("Event Add Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                    ))));
        Get.back();
        eventGet(status: "upcoming");

      }
      else{
        add.value = false;
        print("error msg ${responseData["errorMsg"].toString()}");
      }
    }
    else{
      add.value = false;
      print("status code ${response.statusCode}");
      }
    return false;
  }
  catch(error){
    print("Add Error ${error.toString()}");
    return false;
  }
  finally{
    add.value = false;
  }
  }

  ///edit event
  Future<bool> eventEdit(context,{required String ID}) async {
    try{
      print("update image image api ${event.value} ");
      edit.value = true;
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
      ///start date convert
      final DateTime parseDate =DateFormat("dd-MM-yyyy").parse(startDate.text.trim());
      final String apiDate = DateFormat("yyyy-MM-dd").format(parseDate);

      ///end date convert
      final DateTime parseEndDate =DateFormat("dd-MM-yyyy").parse(endDate.text.trim());
      final String apiEndDate = DateFormat("yyyy-MM-dd").format(parseEndDate);


      ///24 hours convert
      int startH = int.parse(startTime.text.trim());
      int startM = int.parse(startMin.text.trim());

      if(isAmSelected.value){
        if(startH == 12) startH = 0;
      }
      else{
        if(startH != 12) startH += 12;
      }
      final String apiTime =  "${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}";

      int endH = int.parse(endTime.text.trim());
      int endM = int.parse(endMin.text.trim());

      if(isPmSelected.value == false){
        if(endH != 12) endH += 12;
        // if(endH == 12) endH = 0;
      }
      else{
        if(endH == 12) endH = 0;
      }
      final String apiEndTime =
          "${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}";

      print("update image image api ${event.value} ");
      Map<String,dynamic> eventMap = {
        "event_id" : ID,
        "title" : eventName.text.trim(),
        "description" : description.text.trim(),
        if(event.value.startsWith("http") == false)"img" : imageFile(event.value),
        "location" : location.text.trim(),
        // "address" : "hrllo",
        "start_datetime" : "${apiDate} ${apiTime}:00",
        "end_datetime" : "${apiEndDate} ${apiEndTime}:59",
        "live_url" : liveLink.text.trim(),
      };

      print("update image image api ${event.value} ");

      print("Event Map  update ${eventMap}");
      print("${startTime.text.trim()} ${startMin.text.trim()} ${isAmSelected.value == true ? "AM" : "PM"}");
      print("${apiEndDate} ${apiEndTime}:59 ${isPmSelected.value == true ? "PM" : "AM"}");


      final response = await http.put(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.event}"),
          headers: {
            "Content-Type" : "Application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(eventMap)
      );

      print("update image image api ${event.value} ");
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          event.value = "";
          eventName.clear();
          location.clear();
          description.clear();
          startDate.clear();
          endDate.clear();
          startTime.clear();
          startMin.clear();
          endTime.clear();
          endMin.clear();
          liveLink.clear();
          edit.value = false;
          ///success
          print("success event update");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: appColors.selectedColor.value,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text("Update Event Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          Get.back();
          eventGet(status: "upcoming");

        }
        else{
          add.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("Add Error ${error.toString()}");
      return false;
    }
    finally{
      add.value = false;
    }
  }

  ///delete
  Future<bool> eventDelete({required String id}) async {

    try{
      delete.value = true;

      Map<String,dynamic> eventMap = {
        "event_id" : id,
      };

      print("delete event ${eventMap}");

      final response = await http.delete(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.event}"),
          headers: {
            "Content-Type" : "Application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(eventMap)
      );


      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          ///success
          print("success event delete");

          Get.back();
          Get.back();
          Get.back();
          eventGet(status: "upcoming");
        }
        else{
          delete.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        delete.value = false;
        print("status code ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      delete.value = false;
      print("Add Error ${error.toString()}");
      return false;
    }
    finally{
      delete.value = false;
    }
  }

  ///get event
  Future<void> eventGet({required String status}) async {
    try {
      get.value = true;

      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.event}&status=${status}"),
          headers: {
            "Content-Type": "Application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          get.value = false;
          print("--------- api success get event ---------");
          listOfEvent.value = List<Map<String, dynamic>>.from(responseData["data"]);
          print("list of event ${listOfEvent.toString()}");
        }
        else {
          get.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else {
        get.value = false;
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("Add Error ${error.toString()}");
    }
    finally{
      get.value = false;
    }
  }


  Future<void> profileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        event.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }

}
