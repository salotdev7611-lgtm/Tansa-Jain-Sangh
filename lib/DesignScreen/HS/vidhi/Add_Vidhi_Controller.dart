import 'dart:convert';
import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';
import '../../../TextTheme/text_theme.dart';

class AddVidhiController extends GetxController{

  AppColors appColors = AppColors();
  TextEditingController search = TextEditingController();

  TextEditingController title = TextEditingController();
  TextEditingController tithiDate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController startTimeMin = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController endTimeMin = TextEditingController();
  TextEditingController whichDay = TextEditingController();
  TextEditingController whichTime = TextEditingController();
  SingleValueDropDownController surname = SingleValueDropDownController();

  RxList<TextEditingController> pujaEssentials = <TextEditingController>[].obs;


  RxList<TextEditingController> cookingTitle = <TextEditingController>[].obs;
  RxList<TextEditingController> cookingDescription = <TextEditingController>[].obs;

  RxList<Map<String, dynamic>> listOfVidhi = <Map<String,dynamic>>[].obs;
  RxList<Map<String, dynamic>> listOfVidhiSearch = <Map<String,dynamic>>[].obs;
  RxString userSurname = "".obs;



  @override
  void onInit() {
    pujaEssentials.add(TextEditingController()); // first field

    cookingTitle.add(TextEditingController());
    cookingDescription.add(TextEditingController());
    super.onInit();
  }

  void addPlace() {
    pujaEssentials.add(TextEditingController());
  }


  void cooking(){
    cookingTitle.add(TextEditingController());
    cookingDescription.add(TextEditingController());
  }

  void removePlace(int index) {
    if (pujaEssentials.length > 1) {
      pujaEssentials.removeAt(index);
    }
  }


  void removeCooking(int index){
    if(cookingTitle.length > 1 && cookingDescription.length > 1){
      cookingTitle.removeAt(index);
      cookingDescription.removeAt(index);
    }
  }

  RxBool isAmSelected = true.obs;
  RxBool isPmSelected = true.obs;
  RxBool vidhiUpdate = false.obs;
  RxString vidhiImage = "".obs;

  RxBool add = false.obs;
  RxBool edit = false.obs;
  RxBool delete = false.obs;
  RxBool get = false.obs;

  ///add vidhi
  Future<bool> addVidhi(context) async{
    try{
      add.value = true;

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

      Map<String, dynamic> vidhi = {
        "surname": surname.dropDownValue!.value.toString(),
        "title": title.text.trim(),
        "tithi_date": tithiDate.text.trim(),
        "description": description.text.trim(),
        "poster": imageFile(vidhiImage.value),
        "pooja_essentials": pujaEssentials.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
        "detailed_description": List.generate(cookingTitle.length, (index) =>
        {
            "title": cookingTitle[index].text.trim(),
            "description": cookingDescription[index].text.trim(),
          },
        ),
      };

      print("Vidhi Map ${vidhi}");
      print("Vidhi Map ${pujaEssentials.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList()}");
      print("Vidhi Image ${vidhiImage.value}");

      final response = await http.post(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.vidhi}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(vidhi),
      );

      print("object ${ApiUrl.token}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if(responseData["success"] == true){
          print("----- Add vidhi successfully -------");
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
                        child: Text("Vidhi Add Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          add.value = false;
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
          add.value = false;
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
          return false;
        }
        return true;
      }
      else{
        print("status code ${response.statusCode}");
        add.value = false;
        return false;
      }
    }
    catch(e){
      print("Add Error ${e.toString()}");
      add.value = false;
      return false;
    }
    finally{
      add.value = false;
    }
  }

  ///edit vidhi
  Future<bool> editVidhi(context,{required String id}) async {
    try{
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

      Map<String, dynamic> editVidhi = {
        "vidhi_id" : id,
        "surname": surname.dropDownValue!.value.toString(),
        "title": title.text.trim(),
        "tithi_date": tithiDate.text.trim(),
        "description": description.text.trim(),
        if(vidhiImage.value.startsWith("http") == false) "poster": imageFile(vidhiImage.value),
        "pooja_essentials": pujaEssentials.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
        "detailed_description": List.generate(cookingTitle.length, (index) =>
        {
          "title": cookingTitle[index].text.trim(),
          "description": cookingDescription[index].text.trim(),
        },
        ),
      };

      print("editVidhi edit ${editVidhi}");

      final response = await http.put(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.vidhi}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(editVidhi),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("----- Edit vidhi successfully -------");
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
                        child: Text("Vidhi Update Successfully",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                      ))));
          Get.back();
          Get.back();
          getVidhi(surname: "DOSHI");
          edit.value = false;
          return true;
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
          edit.value = false;
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
        print("status code ${response.statusCode}");
        edit.value = false;
      }
      return false;
    }
    catch(error){
      print("Error ${error.toString()}");
      edit.value = false;
      return false;
    }
    finally{
      edit.value = false;
    }
  }

  ///delete vidhi
  Future<bool> deleteVidhi(context,{required String id}) async {
    try{
      delete.value = true;

      Map<String,dynamic> deleteVidhi = {
        "vidhi_id" : id,
      };

      print("vidhi delete id ${deleteVidhi}");

      final response = await http.delete(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.vidhi}"),
        headers: {
          "Content-Type" : "Application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(deleteVidhi),
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          print("----- Delete vidhi successfully -------");
          Get.back();
          Get.back();
          Get.back();
          getVidhi(surname: "DOSHI");
        }
      }
      return false;
    }
    catch(error){
      print("Error ${error.toString()}");
      delete.value = false;
      return false;
    }
    finally{
      delete.value = false;
    }
  }

  ///get vidhi
  Future<void> getVidhi({required String surname}) async {
    try{
      get.value = true;

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.vidhi}&surname=${surname}"),
        headers: {
          "Content-Type" : "Application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
      );

      print("surname ${surname}");
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("response ${responseData["data"]}");

          print("------------- get vidhi success ---------------");
          listOfVidhi.value = List<Map<String,dynamic>>.from(responseData["data"]);
          listOfVidhiSearch.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("list of vidhi ${listOfVidhi.toString()}");
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
          get.value = false;
        }
      }
      else{
        print("status code ${response.statusCode}");
        get.value = false;
      }
    }
    catch(error){
      get.value = false;
      print("Error ${error.toString()}");
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
        vidhiImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }



  void runFilter(String keyword) {
    if (keyword.isEmpty) {
      listOfVidhi.value =
      List<Map<String, dynamic>>.from(listOfVidhiSearch);
    } else {
      listOfVidhi.value = listOfVidhiSearch.where((member) {

        final name = "${member["title"] ?? ""}".toLowerCase();

        final mobile = (member["tithi_date"] ?? "").toString().toLowerCase();

        final searchText = keyword.toLowerCase();

        return name.contains(searchText) ||
            mobile.contains(searchText);

      }).toList();
    }
  }



}
