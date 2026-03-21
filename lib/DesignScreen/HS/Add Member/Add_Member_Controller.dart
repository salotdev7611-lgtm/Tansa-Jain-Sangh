import 'dart:convert';
import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeAdd/Home_Add.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../TextTheme/text_theme.dart';
import 'Family_Member.dart';

class AddMemberController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final SelectFatherController selectFatherController = Get.put(SelectFatherController());

  GlobalKey<FormState> addMemberKey = GlobalKey();
  TextEditingController name = TextEditingController();
  Rx<SingleValueDropDownController>lastName = Rx<SingleValueDropDownController>(SingleValueDropDownController());
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

  GlobalKey<FormState> addWifeKey = GlobalKey();
  TextEditingController wifeName = TextEditingController();
  SingleValueDropDownController wifeSurname = SingleValueDropDownController();
  TextEditingController wifeDateOfBirth = TextEditingController();
  TextEditingController wifeDeathDate = TextEditingController();
  TextEditingController wifeNumber = TextEditingController();
  TextEditingController wifeEmail = TextEditingController();
  TextEditingController wifeBloodGroup = TextEditingController();

  SingleValueDropDownController wifeProfession = SingleValueDropDownController();
  TextEditingController wifeSubProfession = TextEditingController();
  TextEditingController wifeBusinessEmail = TextEditingController();
  TextEditingController wifeBusinessNumber = TextEditingController();
  TextEditingController wifeBusinessAddress = TextEditingController();

  RxString profileImage = "".obs;
  RxString wifeProfileImage = "".obs;
  RxString errorMsg = "".obs;

  RxBool leaving = true.obs;
  RxBool death = false.obs;

  RxBool married = false.obs;
  RxString marriedName = "".obs;
  RxString marriedLastName = "".obs;
  RxString marriedImage = "".obs;
  RxString marriedNumber = "".obs;
  // RxString profileImage = "".obs;
  RxString dateOfBirthday = "".obs;
  RxString bloodGroupWife = "".obs;
  RxBool add = false.obs;
  RxBool edit = false.obs;

  RxString memberId = "".obs;
  RxBool addApiCall = false.obs;


  /// add member
  Future<bool> addMember({String? fatherId, String? motherId}) async {
    try {
      add.value = true;

      Map<String, dynamic> fileWife(String path) {
        if (path.isNotEmpty && File(path).existsSync()) {
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte": fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte": [],
          "extension": "",
        };
      }

      Map<String, dynamic> fileFather(String path) {
        if (path.isNotEmpty && File(path).existsSync()) {
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte": fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte": [],
          "extension": "",
        };
      }

      Map<String, dynamic> fileMother(String path) {
        if (path.isNotEmpty && File(path).existsSync()) {
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte": fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte": [],
          "extension": "",
        };
      }

      Map<String, dynamic> filePerson(String path) {
        if (path.isNotEmpty && File(path).existsSync()) {
          Uint8List fileBytes = File(path).readAsBytesSync();
          return {
            "byte": fileBytes,
            "extension": path.split('.').last,
          };
        }
        return {
          "byte": [],
          "extension": "",
        };
      }
      String wifeApiDate = "";
      if (wifeDateOfBirth.text.trim().isNotEmpty) {
        final DateTime wifeDate = DateFormat("dd-MM-yyyy").parse(wifeDateOfBirth.text.trim());
        wifeApiDate = DateFormat("yyyy-MM-dd").format(wifeDate);
      }

      String wifeApiDeath = "";
      if (wifeDeathDate.text.trim().isNotEmpty) {
        final DateTime wifeDeath = DateFormat("dd-MM-yyyy").parse(wifeDeathDate.text.trim());
        wifeApiDeath = DateFormat("yyyy-MM-dd").format(wifeDeath);
      }

      Map<String, dynamic> wife = {
        "name": wifeName.text.trim(),
        "profile_img": fileWife(wifeProfileImage.value),
        "gender" : "f",
        "surname": wifeSurname.dropDownValue?.value?.toString() ?? "",
        "mobile_no": wifeNumber.text.trim(),
        "dob": wifeApiDate,
        "email": wifeEmail.text.trim(),
        "blood_group": wifeBloodGroup.text.trim(),
        "carrier_type": wifeProfession.dropDownValue?.value?.toString() ?? "",
        "profession": wifeProfession.dropDownValue?.value?.toString() ?? "",
        "sub_profession": wifeSubProfession.text.trim(),
        "company_name": "",
        "business_address": wifeBusinessAddress.text.trim(),
        "business_city": "",
        "business_state": "",
        "business_country": "",
        "death_date": wifeApiDeath,
      };


      Map<String, dynamic> father = {
        "id": selectFatherController.nameFather.isNotEmpty
            ? selectFatherController.fatherID.value
            : "",
        "name": selectFatherController.fatherName.text.trim(),
        "profile_img": fileFather(selectFatherController.fatherImage.value),
        "gender" : "m",
        "mobile_no": selectFatherController.fatherNumber.text.trim(),
      };

      Map<String, dynamic> mother = {
        "id": selectFatherController.nameMother.isNotEmpty
            ? selectFatherController.motherID.value
            : "",
        "name": selectFatherController.wifeName.text.trim(),
        "profile_img": fileMother(selectFatherController.wifeImage.value),
        "gender" : "f",
        "mobile_no": selectFatherController.wifeNumber.text.trim(),
      };

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

      Map<String, dynamic> member = {
        "father": father,
        "mother": mother,
        "name": name.text.trim(),
        "profile_img": filePerson(profileImage.value),
        "surname": lastName.value.dropDownValue?.value?.toString() ?? "",
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

      if (appRadioButtonController.selectedIndexMarital.value == 1) {
        member["partner"] = wife;
      }

      print("object 7878 ${appRadioButtonController.selectedIndexMarital.value}");

      print("MEMBER => $member");
      print("WIFE => $wife");
      print("FATHER => $father");
      print("MOTHER => $mother");
      print("surname ${lastName.value.dropDownValue?.value?.toString() ?? ""}");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
        body: jsonEncode(member),
      );

      print("response body ${response.body}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("------- Add Member -------");
          Get.to(FamilyMember(
            name: name.text.toString(),
            lastName: lastName.value.dropDownValue?.name ?? "",
            mobileNo: number.text.toString(),
            image: profileImage.value.toString(),
            status: appRadioButtonController.selectedIndexMarital == 1 ? "Married" : "Unmarried",
            wifeName: marriedName.value,
            wifeLastName: marriedLastName.value,
            wifeImage: marriedImage.value,
            wifeNumber: marriedNumber.value,
          ),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          print("image ${profileImage.value}");
          add.value = false;
        }
        else{
          add.value = false;
          errorMsg.value = responseData["errorMsg"].toString();
          print("error msg ${errorMsg.toString()}");
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
      }
      return true;
    } catch (e) {
      add.value = false;
      print("ADD MEMBER ERROR => $e");
      return false;
    } finally {
      add.value = false;
    }
  }


  ///add wife
  Future<bool> addWife() async {
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
          "extension": "",
        };
      }

      String wifeApiDate = "";
      if (wifeDateOfBirth.text.trim().isNotEmpty) {
        final DateTime wifeDate = DateFormat("dd-MM-yyyy").parse(wifeDateOfBirth.text.trim());
        wifeApiDate = DateFormat("yyyy-MM-dd").format(wifeDate);
      }

      String wifeApiDeath = "";
      if (wifeDeathDate.text.trim().isNotEmpty) {
        final DateTime wifeDeath = DateFormat("dd-MM-yyyy").parse(wifeDeathDate.text.trim());
        wifeApiDeath = DateFormat("yyyy-MM-dd").format(wifeDeath);
      }

      Map<String, dynamic> member = {
        "husband_wife_of": memberId.value,
        "name": wifeName.text.trim(),
        "gender" : "f",
        "profile_img": file(wifeProfileImage.value),
        "surname": wifeSurname.dropDownValue?.value?.toString() ?? "",
        "mobile_no": wifeNumber.text.trim(),
        "dob": wifeApiDate,
        "email": wifeEmail.text.trim(),
        "blood_group": wifeBloodGroup.text.trim(),
        "carrier_type": wifeProfession.dropDownValue?.value?.toString() ?? "",
        "profession": wifeProfession.dropDownValue?.value?.toString() ?? "",
        "sub_profession": wifeSubProfession.text.trim(),
        "company_name": "",
        "business_address": wifeBusinessAddress.text.trim(),
        "business_city": "",
        "business_state": "",
        "business_country": "",
        "death_date": wifeApiDeath,
      };

      print("MEMBER only wife data are add => $member");

      final response = await http.post(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          },
          body: jsonEncode(member),
        );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("add wife successfully");
          }
        else{
          add.value = false;
          errorMsg.value = responseData["errorMsg"].toString();
          print("error msg ${errorMsg.toString()}");
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
      }
      return false;
    } catch (e) {
      add.value = false;
      print("ADD MEMBER ERROR => $e");
      return false;
    } finally {
      add.value = false;
    }
  }

  ///add parent
  Future<bool> addParent() async {
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
          "extension": "",
        };
      }

      Map<String,dynamic> parent = {
        "parent_of":  selectFatherController.sonId.value,
        "name": selectFatherController.fatherName.text.trim(),
        "profile_img": file(selectFatherController.fatherImage.value),
        "mobile_no": selectFatherController.fatherNumber.text.trim(),
        "gender" : "m",
        "partner" : {
          "name": selectFatherController.wifeName.text.trim(),
          "profile_img": file(selectFatherController.wifeImage.value),
          "gender" : "f",
          "surname" : lastName.value.dropDownValue?.value?.toString() ?? "",
          "mobile_no": selectFatherController.wifeNumber.text.trim(),
        },
        "surname" : lastName.value.dropDownValue?.value?.toString() ?? "",
      };

      print("add new parent ${parent}");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
        },
        body: jsonEncode(parent),
      );

      print("response data ${response.body}");

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){

          print("add new parent successfully");

          await getParent();

          print("List of member Father ID 1 ${member}");

          print("new father id ${member[0]["father"]["id"]}");
          selectFatherController.sonId.value = member.first["father"]["id"];
          print("selectFatherController.sonId.value ${selectFatherController.sonId.value}");
        }
        else{
          add.value = false;
          errorMsg.value = responseData["errorMsg"].toString();
          print("error msg ${errorMsg.toString()}");
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      return false;
    }
  }



  ///edit member
  Future<bool> editMember() async {
    try{
      edit.value = true;

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

      Map<String, dynamic> member = {
        "member_id" : memberId.value,
        "name": name.text.trim(),
        if(profileImage.value.startsWith("http") == false)"profile_img": file(profileImage.value),
        "surname": lastName.value.dropDownValue?.value?.toString() ?? "",
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


      print("member edit details ${member}");

      print("success to call");
       final response = await http.put(
         Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}"),
         headers: {
           "Content-Type" : "application/json",
           "x-api-key" : ApiUrl.xApikey,
           "Authorization" : ApiUrl.token,
         },
         body: jsonEncode(member),
       );

       if(response.statusCode == 200){
         final responseData = jsonDecode(response.body);
         if(responseData["success"] == true) {
           /// edit member successfully
           print("------ update member ------");

           Get.to(HomeAdd(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));

           edit.value = false;
         }
         else {
           edit.value = false;
           errorMsg.value = responseData["errorMsg"].toString();
           print("error msg ${errorMsg.toString()}");
         }
       }
       else{
         edit.value = false;
         print("status code ${response.statusCode}");
       }
      return true;
    }
    catch(error){
      edit.value = false;
      print("add member error ${error.toString()}");
      return false;
    }
    finally{
      edit.value = false;
    }
  }

  RxList<Map<String,dynamic>> member = <Map<String,dynamic>>[].obs;

  Future<void> getParent() async {
    try{

      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&member_id=${selectFatherController.sonId.value}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          member.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("List of member Father ID ${member}");
        }
      }
    }
    catch(error){
      print("Error ${error}");
    }
  }


  Future<void> profileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        profileImage.value = image.path;
        update();
      }
      return;
    }
    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }
  Future<void> wifeProfileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        wifeProfileImage.value = image.path;
        update();
      }
      return;
    }
    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }
}