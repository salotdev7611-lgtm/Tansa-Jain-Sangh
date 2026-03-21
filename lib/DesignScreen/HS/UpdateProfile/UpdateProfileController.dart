import 'dart:convert';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
class UpdateProfileController extends GetxController{

  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  final formKey  = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  SingleValueDropDownController lastName = SingleValueDropDownController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController deathDate = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();


  SingleValueDropDownController profession = SingleValueDropDownController();
  TextEditingController subProfession = TextEditingController();
  TextEditingController businessEmail = TextEditingController();
  TextEditingController businessNumber = TextEditingController();
  TextEditingController businessAddress = TextEditingController();


  RxString profile = "".obs;


  Future<bool> updateProfile(String memberId) async {
    try{

      Map<String, dynamic> file(String path) {
        if (path.isNotEmpty && File(path).existsSync()) {
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte": fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte": [],
          "extension": path.split('.').last,
        };
      }

      String memberDob = "";
      if (dateOfBirth.text.trim().isNotEmpty) {
        final DateTime dob = DateFormat("dd-MM-yyyy").parse(dateOfBirth.text.trim());
        memberDob = DateFormat("yyyy-MM-dd").format(dob);
      }

      String memberDeath = "";
      if (deathDate.text.trim().isNotEmpty) {
        final DateTime death = DateFormat("dd-MM-yyyy").parse(deathDate.text.trim());
        memberDeath = DateFormat("yyyy-MM-dd").format(death);
      }

      Map<String,dynamic> update = {
        "member_id" : memberId ,
        "name": name.text.trim(),
        if(profile.value.startsWith("http") == false)"profile": file(profile.value),
        "surname": lastName.dropDownValue?.value?.toString() ?? "",
        "mobile_no": number.text.trim(),
        "gender": appRadioButtonController.selectedIndexGender.value == 1
            ? "f"
            : "m",
        "dob": memberDob,
        "email": email.text.trim(),
        "blood_group": bloodGroup.text.trim(),
        "carrier_type": profession.dropDownValue?.value?.toString() ?? "",
        "profession": profession.dropDownValue?.value?.toString() ?? "",
        "sub_profession": subProfession.text.trim(),
        "company_name": "",
        "business_address": businessAddress.text.trim(),
        "business_city": "",
        "business_state": "",
        "business_country": "",
        "death_date": memberDeath,
      };

      print("update the member details ${update}");

      final response = await http.put(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(update),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          loginScreenController.checkLoginStatus();
          Get.back();
          print("------- update member successfully -------");
          return true;
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("error $error");
      return false;
    }
  }


  Future<void> profileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        profile.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }
}