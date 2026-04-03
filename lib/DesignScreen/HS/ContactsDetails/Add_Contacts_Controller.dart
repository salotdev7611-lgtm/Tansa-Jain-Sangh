import 'dart:convert';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Contacts_Controller.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Explore_Contacts_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../../Helpers/api_url.dart';

class AddContactsController extends GetxController{

  final AppColors appColors = Get.put(AppColors());

  final ExploreContactsController exploreContactsController = Get.put(ExploreContactsController());

  GlobalKey<FormState> memberDetails = GlobalKey();
  TextEditingController searchFather = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController pinCode = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  SingleValueDropDownController surname = SingleValueDropDownController();
  TextEditingController mobileNo = TextEditingController();

  TextEditingController fatherName = TextEditingController();
  TextEditingController fatherMobileNo = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController deathDate = TextEditingController();
  RxString fatherImage = "".obs;

  TextEditingController motherName = TextEditingController();
  TextEditingController motherMobileNo = TextEditingController();
  TextEditingController dobMother = TextEditingController();
  TextEditingController deathDateMother = TextEditingController();
  RxString motherImage = "".obs;




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
  RxBool selectFatherName = false.obs;
  RxBool change = false.obs;
  RxString lastIndexName = "".obs;



  RxString imageFather = "".obs;
  RxString nameFather = "".obs;
  RxString mobileNoFather = "".obs;
  RxString birthDateFather = "".obs;
  RxString deathDateFather = "".obs;

  RxString imageMother = "".obs;
  RxString nameMother = "".obs;
  RxString mobileNoMother = "".obs;
  RxString birthDateMother = "".obs;
  RxString dateDeathMother = "".obs;

  RxString id = "".obs;

  RxString profileImage = "".obs;

  RxBool add = false.obs;
  RxBool get = false.obs;

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

  /// BUILD GRANDPARENTS MAP

  Map<String, dynamic> buildGrandParents() {
    Map<String, dynamic>? currentAncestor;

    /// helper for safe date conversion
    String safeApiDate(String value) {
      if (value.trim().isEmpty) return "";

      try {
        final date = DateFormat("dd-MM-yyyy").parse(value.trim());
        return DateFormat("yyyy-MM-dd").format(date);
      } catch (e) {
        print("Invalid date: $value");
        return "";
      }
    }

    for (int i = selectedFatherNames.length - 1; i >= 1; i--) {

      final String gfDob = i < fatherDob.length
          ? safeApiDate(fatherDob[i])
          : "";

      final String gfDeath = i < fatherDeathDate.length
          ? safeApiDate(fatherDeathDate[i])
          : "";

      final String gmDob = i < motherDob.length
          ? safeApiDate(motherDob[i])
          : "";

      final String gmDeath = i < motherDeathDate.length
          ? safeApiDate(motherDeathDate[i])
          : "";

      Map<String, dynamic> level = {
        "father": {
          "name": i < selectedFatherNames.length ? selectedFatherNames[i] : "",
          "mobile_no": i < selectedFatherNumber.length ? selectedFatherNumber[i] : "",
          "profile": i < selectedFatherImages.length
              ? imageFile(selectedFatherImages[i])
              : imageFile(imageFather.value),
          "dob": gfDob,
          "death_date": gfDeath,
        },

        "mother": {
          "name": i < selectedMotherNames.length ? selectedMotherNames[i] : "",
          "mobile_no": i < selectedMotherNumber.length ? selectedMotherNumber[i] : "",
          "profile": i < selectedMotherImages.length
              ? imageFile(selectedMotherImages[i])
              : imageFile(imageMother.value),
          "dob": gmDob,
          "death_date": gmDeath,
        }
      };
      print("Father ${gfDob}");
      print("Father death_date  ${gfDeath}");
      print("Mother ${gmDob}");
      print("Mother death_date ${gmDeath}");

      /// nest previous ancestor
      if (currentAncestor != null) {
        level["ancestor"] = currentAncestor;
      }

      currentAncestor = level;
    }

    return currentAncestor ?? <String, dynamic>{};
  }




  /// ADD MEMBER
  Future<bool> addMember() async{
    try{

      add.value = true;
      /// helper: safe date convert (dd-MM-yyyy → yyyy-MM-dd)
      String safeApiDate(String value) {
        if (value.trim().isEmpty) return "";

        try {
          final date = DateFormat("dd-MM-yyyy").parse(value.trim());
          return DateFormat("yyyy-MM-dd").format(date);
        } catch (e) {
          print("Invalid date format: $value");
          return "";
        }
      }

      ///  Father DOB
      final String apiDate = safeApiDate(dob.text);
      final String apiDateSecond = safeApiDate(birthDateFather.value);

      /// FATHER DEATH DATE
      final String deathDateApi = safeApiDate(deathDate.text);
      final String FDD = safeApiDate(deathDateFather.value);

      /// MOTHER DOB
      final String dateOfBirthApiDate = safeApiDate(dobMother.text);
      final String motherDobSecond = safeApiDate(birthDateMother.value);

      /// MOTHER DEATH DATE
      final String deathDateApiMother = safeApiDate(deathDateMother.text);
      final String MDD = safeApiDate(dateDeathMother.value);

      /// API MAP
      Map<String, dynamic> member = {
        // "address": address.text.trim(),
        // "city": city.text.trim(),
        // "state": state.text.trim(),
        // "country": country.text.trim(),
        // "pincode": pinCode.text.trim(),
        "profile": imageFile(profileImage.value),
        "name": name.text.trim(),
        "mobile_no": mobile.text.trim(),
        "surname": surname.dropDownValue!.value.toString(),

        "ancestor": {
          "father": {
            "name": fatherName.text.trim().isEmpty
                ? nameFather.value
                : fatherName.text.trim(),

            "mobile_no": fatherMobileNo.text.trim().isEmpty
                ? mobileNoFather.value
                : fatherMobileNo.text.trim(),

            "profile": fatherImage.value.isEmpty
                ? imageFile(imageFather.value)
                : imageFile(fatherImage.value),

            "dob": apiDate.isEmpty ? apiDateSecond : apiDate,
            "death_date": deathDateApi.isEmpty ? FDD : deathDateApi,
          },
          "mother": {
            "name": motherName.text.trim().isEmpty
                ? nameMother.value
                : motherName.text.trim(),

            "mobile_no": motherMobileNo.text.trim().isEmpty
                ? mobileNoMother.value
                : motherMobileNo.text.trim(),

            "profile": motherImage.value.isEmpty
                ? imageFile(imageMother.value)
                : imageFile(motherImage.value),

            "dob": dateOfBirthApiDate.isEmpty
                ? motherDobSecond
                : dateOfBirthApiDate,

            "death_date": deathDateApiMother.isEmpty
                ? MDD
                : deathDateApiMother,
          },
          "ancestor": buildGrandParents(),
        }
      };

      print("all data check for the date ${member}");
      print("apiDate ${apiDate}");
      print("apiDateSecond ${apiDateSecond}");
      print("deathDateApi ${deathDateApi}");
      print("FDD ${FDD}");
      print("dateOfBirthApiDate ${dateOfBirthApiDate}");
      print("motherDobSecond ${motherDobSecond}");
      print("deathDateApiMother ${deathDateApiMother}");
      print("MDD ${MDD}");

      print("all data check for the date grand father mother ${buildGrandParents()}");

       final response = await http.post(
         Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.familyAddresses}"),
         headers: {
           "Content-Type": "application/json",
           "x-api-key": ApiUrl.xApikey,
           "Authorization": ApiUrl.token,
         },
         body: jsonEncode(member),
      );
      print("all the data first ${member.toString()}");

       print("main response Data ${response.body}");

      if(response.statusCode == 200){
        add.value = true;
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("all the data ${member.toString()}");
          print("----- Add member successfully -------");
          print("object ${buildGrandParents()}");
          Get.back();
          add.value = false;
          exploreContactsController.mainMember("house_main_person");
          return true;
        }
        else{
          add.value = false;
          print("error msg ${responseData["errorMsg"].toString()}");
          return false;
        }
      }
      else{
        add.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      add.value = false;
      print("Error ${error.toString()}");
      return false;
    }
    finally {
      add.value = false;
    }
  }

  RxList<Map<String, dynamic>> listOfFather = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> ancestorList = <Map<String, dynamic>>[].obs;


  ///search data api
  Future<void> getFather({required String father,required String surname}) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&search_str=${father}&surname=${surname}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print("search_str ${father} & surname ${surname}");
      print("-----------------");
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          listOfFather.value = List<Map<String,dynamic>>.from(responseData["data"]);

          print("Users loaded: ${listOfFather.length}");


          print("Normalized listOfFather => $listOfFather");
        } else {
          Get.snackbar("Error", responseData["errorMsg"].toString());
        }
      } else {
        Get.snackbar("Error", "Server error");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  List<Map<String, dynamic>> getFilterList(String query) {
    if (query.isEmpty) {
      // No input: return all users
      return listOfFather;
    }
    // Filter by fname or email
    final filtered = listOfFather.where((item) {
      final name = (item['name'] ?? '').toString().toLowerCase();
      final q = query.toLowerCase();

      return name.contains(q);
    }).toList();

    return filtered;
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
          Uri.parse("${ApiUrl.adminBaseUrl}${ApiUrl.membersList}&father=${fatherId}"),
          headers: {
            "Content-Type": "application/json",
            "x-api-key": ApiUrl.xApikey,
            "Authorization": ApiUrl.token,
          }
      );

      print("ID FATHER ${id}");

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("get member");

          listOfFamilyMember.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("Data print${listOfFamilyMember}");
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
        profileImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }

  Future<void> fatherImagePicker() async {
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

  Future<void> motherImagePicker() async {
    final ImagePicker picker = ImagePicker();

    var status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        motherImage.value = image.path;
        update();
      }
      return;
    }

    Get.snackbar("Permission Denied",
        "Please allow Photos access. Select 'Allow all photos'.");
  }


}