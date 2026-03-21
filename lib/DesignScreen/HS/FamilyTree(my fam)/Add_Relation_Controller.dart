import 'dart:convert';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/Widgets/RadioButtons/app_radio_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import '../../../Helpers/api_url.dart';

class AddRelationController extends GetxController{


  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());

  TextEditingController searchFather = TextEditingController();


  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstName = TextEditingController();
  SingleValueDropDownController lastName = SingleValueDropDownController();
  SingleValueDropDownController profession = SingleValueDropDownController();
  TextEditingController describeProfession = TextEditingController();
  TextEditingController businessEmail = TextEditingController();
  TextEditingController businessContact = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController deathDate = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  RxString profileImage = "".obs;


  GlobalKey<FormState> wifeFormKey = GlobalKey();
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
  RxString wifeProfileImage = "".obs;

  RxBool married = false.obs;
  RxString marriedName = "".obs;
  RxString marriedLastName = "".obs;
  RxString marriedImage = "".obs;
  RxString marriedNumber = "".obs;

  ///parent
  RxString fatherID = "".obs;
  RxString imageFather = "".obs;
  RxString nameFather = "".obs;

  RxString motherID = "".obs;
  RxString imageMother = "".obs;
  RxString nameMother = "".obs;

  RxBool selectFatherName = false.obs;
  RxBool search = false.obs;

  RxList<String> selectedFatherNames = <String>[].obs;
  RxList<String> selectedFatherImages = <String>[].obs;
  RxList<String> selectedFatherNumber = <String>[].obs;
  RxList<String> fatherDob = <String>[].obs;
  RxList<String> fatherDeathDate = <String>[].obs;

  RxList<String> selectedMotherNames = <String>[].obs;
  RxList<String> selectedMotherImages = <String>[].obs;
  RxList<String> selectedMotherNumber = <String>[].obs;
  RxList<String> motherDob = <String>[].obs;
  RxList<String> motherDeathDate = <String>[].obs;

  RxString sonId = "".obs;

  RxString lastIndexName = "".obs;

  RxBool add = false.obs;
  RxBool get = false.obs;

  Future<bool> addRelation() async {
    try{
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
        "profile": fileWife(wifeProfileImage.value),
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
        "id": fatherID.value,
        "gender" : "m",
      };

      Map<String, dynamic> mother = {
        "id": motherID.value,
        "gender" : "f",
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
        "name": firstName.text.trim(),
        "profile": filePerson(profileImage.value),
        "surname": lastName.dropDownValue?.value?.toString() ?? "",
        "mobile_no": mobileNo.text.trim(),
        "gender": appRadioButtonController.selectedIndexGender.value == 1
            ? "f"
            : "m",
        "dob": memberDob,
        "email": email.text.trim(),
        "blood_group": bloodGroup.text.trim(),
        "carrier_type": profession.dropDownValue?.value?.toString() ?? "",
        "profession": profession.dropDownValue?.value?.toString() ?? "",
        "sub_profession": describeProfession.text.trim(),
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

      // print("object 7878 ${appRadioButtonController.selectedIndexMarital.value}");

      print("MEMBER => $member");
      print("WIFE => $wife");
      print("FATHER => $father");
      print("MOTHER => $mother");
      print("surname ${lastName.dropDownValue?.value?.toString() ?? ""}");

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
          print("image ${profileImage.value}");
          add.value = false;
        }
        else{
          add.value = false;
          // errorMsg.value = responseData["errorMsg"].toString();
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

      return false;
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


  RxList<Map<String, dynamic>> listOfFather = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> ancestorList = <Map<String, dynamic>>[].obs;


  Future<void> getParent() async {
    try{

      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&search_str=${searchFather.text}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          listOfFather.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("List of father ${listOfFather}");
        }
      }
    }
    catch(error){
      print("Error ${error}");
    }
  }


  ///recursion function manage
  Future<void> fetchParent({
    required String memberId,
    int depth = 0,
  }) async {
    if (memberId.isEmpty || depth > 10) return;

    try {
      get.value = true;
      final response = await http.get(
        Uri.parse(
          "${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&member_id=$memberId",
        ),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print("member id required ${memberId}");
      if (response.statusCode != 200) return;

      final responseData = jsonDecode(response.body);
      if (responseData["success"] != true) return;

      final data = responseData["data"];
      if (data == null || data.isEmpty) return;

      final member = Map<String, dynamic>.from(data[0]);

      if (ancestorList.any((e) => e["id"] == member["id"])) return;

      ancestorList.add(member);

      selectedFatherNames.addAll([
        "${member["name"] ?? ""} ${member["surname"] ?? ""}".trim(),
      ]);

      print("selectedFatherNames ${selectedFatherNames}");

      final name = "${member["name"]?.toString() ?? ""} ${member["surname"]?.toString() ?? ""}";
      final index = selectedFatherNames.lastIndexOf(name);

      if (index != -1) {
        lastIndexName.value = selectedFatherNames[index];
      } else {
        lastIndexName.value = "";
      }

      print(" 1 ${selectedFatherNames}");
      selectedFatherImages.addAll([
        member["profile_img"] ?? "",
      ]);

      print(" 2 ${selectedFatherImages}");

      selectedFatherNumber.addAll([
        member["mobile_no"] ?? "",
      ]);

      print(" 3 ${selectedFatherNumber}");

      fatherDob.addAll([
        member["dob"] ?? "",
      ]);

      print(" 4 ${fatherDob}");

      fatherDeathDate.addAll([
        member["death_date"] ?? "",
      ]);

      print(" 5 ${fatherDeathDate}");

      selectedMotherNames.addAll([
        "${member["husband_wife_of"]["name"] ?? ""} ${member["husband_wife_of"]["surname"] ?? ""}"
      ]);

      print(" 6 ${selectedMotherNames}");

      selectedMotherImages.addAll([
        member["husband_wife_of"]["profile_img"] ?? "",
      ]);

      print(" 7 ${selectedMotherImages}");

      selectedMotherNumber.addAll([
        member["husband_wife_of"]["mobile_no"] ?? "",
      ]);

      print(" 8 ${selectedMotherNumber}");

      motherDob.addAll([
        member["husband_wife_of"]["dob"] ?? "",
      ]);

      print(" 9 ${motherDob}");

      motherDeathDate.addAll([
        member["husband_wife_of"]["death_date"] ?? "",
      ]);

      print(" 10 ${motherDeathDate}");

      print("new data list ${selectedFatherNames}");

      if (member["father"] != null && member["father"]["id"] != null) {
        await fetchParent(
          memberId: member["father"]["id"],
          depth: depth,
        );
      }

      print("ancestorList ${ancestorList}");

      sonId.value = member["father"]["id"].toString();
      print("new lunch id ${sonId.value}");
      get.value = false;
    }
    catch (e) {
      print("fetchParent error: $e");
    }
  }

  Future<void> loadFullFamilyTree(String memberId) async {
    await fetchParent(memberId: memberId);

    print("memberId ${memberId}");
    print("ancestorList two ${ancestorList}");
  }
  // Search Father List
  List<Map<String, dynamic>> searchFatherList(String query) {
    if (query.isEmpty) {
      // No input: return all users
      return listOfFather;
    }
    final filtered = listOfFather.where((item) {
      final name = (item['name'] ?? '').toString().toLowerCase();
      final q = query.toLowerCase();

      return name.contains(q);
    }).toList();

    return filtered;
  }

  @override
  void onClose() {
    searchFather.dispose();
    wifeName.dispose();
    super.onClose();
  }

  RxList<Map<String,dynamic>> listOfChildren = <Map<String,dynamic>>[].obs;

  Future<void> getChildren({required String fatherId}) async {
    try{


      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&father=${fatherId}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );
      print("fatherId ${ApiUrl.baseUrl}${ApiUrl.membersList}&father=${fatherId}");


      print("Response children ${response.body}");
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          listOfChildren.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("List of children ${listOfChildren.value}");
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
      }
    }
    catch(error){}
  }

}