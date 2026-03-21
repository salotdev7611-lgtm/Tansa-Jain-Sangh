import 'dart:convert';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Bottom_Nav_Bar.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/OTP_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Helpers/api_url.dart';
import '../../../TextTheme/text_theme.dart';

class AdminSettingController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AppColors appColors = Get.put(AppColors());
  final AddVidhiController addVidhiController = Get.put(AddVidhiController());



  /// Dropdown controllers
  RxList<TextEditingController> surname = RxList<TextEditingController>();
  RxInt updates = (-1).obs;
  RxInt editIcon = (-1).obs;
  RxInt activeIndex = (-1).obs;


  /// single focus node
  final FocusNode focusNode = FocusNode();

  void focusAt(int index) {
    activeIndex.value = index;

    // delay ensures widget rebuild completes
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });
  }

  void removeSurname(int index) {
    surname[index].dispose(); // prevent memory leak
    surname.removeAt(index);
  }

  RxList<TextEditingController> profession = RxList<TextEditingController>();
  RxList<DropDownValueModel> surnameList = <DropDownValueModel>[].obs;
  RxList<DropDownValueModel> professionList = <DropDownValueModel>[].obs;


  void removeProfession(int index) {
    profession[index].dispose(); // prevent memory leak
    profession.removeAt(index);
  }

  RxBool status = true.obs;
  RxBool post = true.obs;
  RxBool payment = true.obs;


  GlobalKey<FormState> surnameKey = GlobalKey();
  TextEditingController addSurname = TextEditingController();

  GlobalKey<FormState> professionKey = GlobalKey();
  TextEditingController addProfession = TextEditingController();

  RxList<Map<String,dynamic>> listOfProfession = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> listOfSurname = <Map<String,dynamic>>[].obs;


  RxBool add = false.obs;
  RxBool get = false.obs;
  RxBool edit = false.obs;
  RxBool delete = false.obs;
  RxBool theme = false.obs;

  RxString old_surname = "".obs;
  RxString deleteSurnames = "".obs;
  RxString deleteProfession = "".obs;

  ///profession_master
  Future<bool> addProfessions(context) async{
    try{
      add.value = true;

      print("prefs data ${ApiUrl.token}");
      Map<String ,dynamic> professions = {
        "name" : addProfession.text.trim(),
      };

      debugPrint("data $professions");

      final response =  await http.post(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.profession}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(professions)
      );

      print( "x-api-key : ${ApiUrl.xApikey}");
      print( "Authorization : ${ApiUrl.token}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds -----------");

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
                        child: Text("Add Profession",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          add.value = false;
          return true;
        }

        else{
          add.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
        }

      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      print("Add Catch Error: $error");
      add.value = false;
      return false;
    }
    finally{
      add.value = false;
    }
  }

  ///profession get
  Future<void> getProfession() async {
    try{
      get.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.profession}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

      print( "x-api-key get  : ${ApiUrl.xApikey}");
      print( "Authorization  get : ${ApiUrl.token}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){

          print("----------- Success api responds get -----------");

          final List data = responseData["data"];

          professionList.assignAll(
            data.map(
                  (e) => DropDownValueModel(
                name: e["name"].toString(),
                value: e["name"].toString(),
              ),
            ).toList(),
          );


          listOfProfession.assignAll(List<Map<String, dynamic>>.from(responseData["data"]),);

          profession.clear();

          for(var item in listOfProfession){
            profession.add(
              TextEditingController(
                text: item["name"]?.toString() ?? "",
              ),
            );
          }

          print("All Data ${listOfProfession.toString()}");
        }
        else{
          get.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(padding: EdgeInsetsGeometry.all(8),
                      child: Text(responseData["errorMsg"].toString(),style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                    ),
                  )));
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("error ${error.toString()}");

    }
    finally{
      get.value = false;
    }
  }

  ///profession delete
  Future<bool> professionDelete(context,{required String profession}) async {
    try{
      delete.value = true;

      Map<String,dynamic> deleteProfession = {
        "old_name" : profession
      };

      print("delete profession ${deleteProfession}");

      final response = await http.delete(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.profession}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token
          },
          body: jsonEncode(deleteProfession)
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          print("----------- Success api responds delete -----------");
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
                        child: Text("Delete Profession Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
        }
        else{
          print("----------- else api responds delete -----------");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          delete.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        delete.value = false;
        print("status code ${response.statusCode}");
        return false;
      }


      return false;
    }
    catch(error){
      delete.value = false;
      print("error ${error.toString()}");
      return false;
    }
    finally{
      delete.value = false;
    }
  }

  ///profession edit
  Future<bool> editProfession(context,index,{required String oldProfession}) async{
    try{

      edit.value = true;

      Map<String,dynamic> professionEdit = {
        "name" : profession[index].text.trim(),
        "old_name" : oldProfession,
      };

      debugPrint("data edit new value $professionEdit");

      final response = await http.put(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.profession}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token
        },
        body: jsonEncode(professionEdit)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds -----------");
          Get.back();
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
                        child: Text("Update Profession",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          edit.value = false;
        }
        else{
          edit.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
        }
      }
      else{
        edit.value = false;
        print("status code ${response.statusCode}");
        return false;
      }

      return false;
    }
    catch(error){
      edit.value = false;
      print("error ${error.toString()}");
      return false;
    }
    finally{
      edit.value = false;
    }
  }

  ///surname_master
  Future<bool> addSurnames(context) async{
    try{
      add.value = true;
      Map<String,dynamic> surname = {
        "surname" : addSurname.text.trim(),
      };

      debugPrint("data $surname");

      final response = await http.post(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.surname}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token,
          },
          body: jsonEncode(surname)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds -----------");
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
                        child: Text("Add Surname",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          add.value = false;
          return true;
        }
        else{
          add.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      add.value = false;
      print("error ${error}");
      return false;
    }
    finally{
      add.value = false;
    }
  }

  ///surname get
  Future<void> getSurname() async {
    try{
      get.value = true;

      print("ApiUrl.baseUrl ${ApiUrl.baseUrl}");
      final response = await http.get(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.surname}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
          );


      print("x-Api-key ${ApiUrl.xApikey}");
      print("Authorization ${ApiUrl.token}");
      print("status code ${response.statusCode}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds get -----------");
          final List data = responseData["data"];

          surnameList.assignAll(
            data.map(
                  (e) => DropDownValueModel(
                name: e["surname"].toString(),
                value: e["surname"].toString(),
              ),
            ).toList(),
          );
          listOfSurname.assignAll(
            List<Map<String, dynamic>>.from(responseData["data"]),
          );
          surname.clear();
          for (var item in listOfSurname) {
            surname.add(
              TextEditingController(
                text: item["surname"]?.toString() ?? "",
              ),
            );
          }
          print("All Data ${listOfSurname.toString()}");
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
      get.value = false;
      print("error ${error.toString()}");
    }
    finally{
      get.value = false;
    }
  }

  ///surname edit
  Future<bool> editSurname(context,index,{required String oldSurname}) async {
    try {
      edit.value = true;
      Map<String,dynamic> surnameEdit = {
        "old_surname" : oldSurname,
        "surname" : surname[index].text.trim(),
      };

      debugPrint("data edit new value $surnameEdit");

      final response = await http.put(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.surname}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token
          },
          body: jsonEncode(surnameEdit)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);

        if(responseData["success"] == true) {
          print("----------- Success api responds -----------");
          Get.back();
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
                        child: Text("Update Surname",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          edit.value = false;

        }
        else{
          edit.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
        }
      }
      else{
        edit.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      edit.value = false;
      print("error ${error.toString()}");
      return false;
    }
    finally{
      edit.value = false;
    }
  }

  ///surname delete
  Future<bool> deleteSurname(context,{required String surname}) async {
    try{

      delete.value = true;

      Map<String,dynamic> deleteSurname = {
        "surname" : surname,
      };

      debugPrint("Delete Data ${deleteSurname}");

      final response = await http.delete(
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.surname}"),
          headers: {
            "Content-Type" : "application/json",
            "x-api-key" : ApiUrl.xApikey,
            "Authorization" : ApiUrl.token
          },
          body: jsonEncode(deleteSurname)
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds delete -----------");
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
                        child: Text("Delete Surname Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          delete.value = false;
        }
        else{
          print("----------- else api responds delete -----------");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          delete.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          // Get.back();
        }
      }
      else{
        Get.back();
        delete.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error) {
      Get.back();
      print("error ${error.toString()}");
      delete.value = false;
      return false;
    }
    finally{
      delete.value = false;
    }
  }



  /// Selected theme color
  late final Rx<Color> selectedColor = appColors.selectedColor.value.obs;

  /// change theme color
  Future<bool> changeTheme(context) async{
    try{
      final hexColor = colorToHex(selectedColor.value);

      theme.value = true;
      Map<String, dynamic> color = {
        "color": hexColor,
      };


      debugPrint("data $color");

      final response = await http.put(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.themeColor}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(color)
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){

          debugPrint("data success  $color");

          print("----------- Success api responds color -----------");
          // selectedColor.value =appColors.selectedColor.value;
          appColors.selectedColor.value = selectedColor.value;
          // appColors.selectedColor.value=hexColor;
          // Get.back();
          Get.offAll(AdminBottomNavBar());

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
                        child: Text("Update Theme Color",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          theme.value = false;
        }
        else{
          theme.value = false;
          print("response error ${responseData["errorMsg"].toString()}");
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  width: Get.width,
                  content: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(8),
                        child: Text(responseData["errorMsg"].toString(),style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
        }
      }
      else{
        theme.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      theme.value = false;
      print("error ${error.toString()}");
      return false;
    }
    finally{
      theme.value = false;
    }
  }

  /// Change theme color live
  void changeColor(Color color) {
    selectedColor.value = color;

    Get.changeTheme(
      ThemeData(
        primaryColor: color,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _createMaterialColor(color),
        ),
      ),
    );
  }

  String colorToHex(Color color) {
    return '${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color hexToColor(String? hex, {Color fallback = const Color(0xFF085B66)}) {
    if (hex == null) return fallback;

    hex = hex.trim().replaceAll('', '');

    // Auto-fix invalid length
    if (hex.length < 6) {
      hex = hex.padLeft(6, '0');
    }

    if (hex.length != 6) return fallback;

    return Color(int.parse('FF$hex', radix: 16));
  }

  ///post button
  Future<bool> postButton({required bool post}) async {
    try{
      Map<String,dynamic> postMap = {
        "allow":post,
      };

      debugPrint("data $postMap");

      final response = await http.put(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.postAllow}"),
        headers: {
          "Content-Type" : "Application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(postMap),
      );
      print("object 1 ${ApiUrl.xApikey}");
      print("object  2 ${ApiUrl.token}");

      debugPrint("data  1 $postMap");
      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          print("----------- Success api responds -----------");
        }
        else{
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
        return false;
      }
      return false; 
    }
    catch(error){
      print("error ${error.toString()}");
      return false;
    }
  }

  ///chat button
  Future<bool> chatButton({required bool chat}) async {
    try{

      Map<String,dynamic> chatValue = {
        "allow" : chat,
      };

      debugPrint("data $chatValue");

      final response = await http.put(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.chat}"),
        headers:{
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(chatValue),
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds -----------");
        }
        else{
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      print("error ${error.toString()}");
      return false;
    }
  }

  ///payment button
  Future<bool> paymentButton({required bool payment}) async {
    try{

      Map<String,dynamic> paymentValue = {
        "allow" : payment,
      };

      debugPrint("data $paymentValue");

      final response = await http.put(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.payment}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(paymentValue),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----------- Success api responds -----------");
        }
        else{
          print("response error ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
        return false;
      }
      return false;
    }
    catch(error){
      print("error ${error.toString()}");
      return false;
    }
  }



  /// Create MaterialColor from Color
  MaterialColor _createMaterialColor(Color color) {
    final Map<int, Color> swatch = {};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    for (double i = 0.05; i < 1; i += 0.1) {
      final int strength = (i * 1000).round();
      final double ds = 0.5 - i;

      swatch[strength] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
