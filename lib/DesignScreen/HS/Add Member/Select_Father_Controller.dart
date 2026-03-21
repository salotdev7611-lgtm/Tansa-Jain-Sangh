import 'dart:convert';

import 'package:family_app/Helpers/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
class SelectFatherController extends GetxController {

  TextEditingController searchFather = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController fatherNumber = TextEditingController();
  TextEditingController wifeName = TextEditingController();
  TextEditingController wifeNumber = TextEditingController();

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

  RxString lastIndexName = "".obs;

  RxString fatherImage = "".obs;
  RxString wifeImage = "".obs;

  RxBool selectFatherName = false.obs;
  RxBool change = false.obs;
  RxBool get = false.obs;
  // RxInt editIndex = 0.obs;


  RxString fatherID = "".obs;
  RxString imageFather = "".obs;
  RxString nameFather = "".obs;

  RxString motherID = "".obs;
  RxString imageMother = "".obs;
  RxString nameMother = "".obs;

  RxString sonId = "".obs;

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

  RxList<Map<String,dynamic>> listOfFamilyMember = <Map<String,dynamic>>[].obs;

  Future<void> getMember({required String fatherId}) async {
    try{
      final response = await http.get(
          Uri.parse("${ApiUrl.baseUrl}${ApiUrl.membersList}&father=${fatherId}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );
      print("fatherId ${fatherId}");

      // print("ID FATHER ${id}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("get member");

          listOfFamilyMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print user${listOfFamilyMember}");
        }
        else{
          print("error msg ${responseData["errorMsg"].toString()}");
        }
      }
      else{
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      print("Error ${error.toString()}");
    }
    // finally {
    //   get.value = false;
    // }
  }

  Future<void> profileImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        fatherImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }

  Future<void> wifeImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        wifeImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
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

}
