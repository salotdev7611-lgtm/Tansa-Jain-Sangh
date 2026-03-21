import 'dart:convert';
import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import '../../../Widgets/RadioButtons/app_radio_button_controller.dart';
import '../LoginScreen/LoginScreen.dart';

class HomeAddController extends GetxController {

  final AppRadioButtonController appRadioButtonController = Get.put(AppRadioButtonController());
  final AddMemberController addMemberController = Get.put(AddMemberController());
  final SelectFatherController selectFatherController = Get.put(SelectFatherController());

  final AppColors appColors = AppColors();
  GlobalKey<FormState> homeOne = GlobalKey();
  RxString profileImage = "".obs;
  TextEditingController name = TextEditingController();
  RxString relation = "brother".obs;
  SingleValueDropDownController surname = SingleValueDropDownController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController county = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  RxString errorMsg = "".obs;
  GlobalKey<FormState> homeKey = GlobalKey();
  // TextEditingController address = TextEditingController();
  RxBool add = false.obs;
  RxBool edit = false.obs;
  RxBool get = false.obs;
  RxList<Map<String, dynamic>> checkData = <Map<String, dynamic>>[].obs;

  RxString userName = "".obs;
  RxString userMobileNo = "".obs;
  RxString userAddress= "".obs;
  RxString userPinCode = "".obs;


  ///check main member
  Future<void> checkMember() async{
    try{
      get.value = true;
      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.userStatus}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token,
      }
      );
      print("HELLOO ${response.body}");


      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          checkData.value = List<Map<String,dynamic>>.from(responseData["data"]);
          addMemberController.memberId.value = checkData[0]["id"].toString();
          addMemberController.name.text = checkData[0]["name"].toString();
          addMemberController.lastName.value.dropDownValue = DropDownValueModel(
            name: checkData[0]["surname"],
            value: checkData[0]["surname"],
          );
          addMemberController.wifeSurname.dropDownValue = DropDownValueModel(
            name: checkData[0]["surname"]?.toString() ?? "",
            value: checkData[0]["surname"]?.toString() ?? "",
          );
          addMemberController.dateOfBirth.text = (checkData[0]["dob"] == "0000-00-00") ? "" :DateFormat("dd-MM-yyyy").format(DateTime.parse(checkData[0]["dob"] ?? "")) ;
          addMemberController.deathDate.text = (checkData[0]["death_date"] == null|| checkData[0]["death_date"] == "0000-00-00") ? "" : DateFormat("dd-MM-yyyy").format(DateTime.parse(checkData[0]["death_date"]?.toString() ?? ""));
          addMemberController.number.text = checkData[0]["mobile_no"]?.toString() ?? "";
          addMemberController.profileImage.value =
          checkData[0]["profile_img"] != null
              ? checkData[0]["profile_img"].toString()
              : "";

          selectFatherController.fatherID.value = checkData[0]["father"]["id"].toString();
          selectFatherController.nameFather.value = "${checkData[0]["father"]["name"].toString()} ${checkData[0]["father"]["surname"].toString()}";
          selectFatherController.imageFather.value = checkData[0]["father"]["profile_img"].toString();

          selectFatherController.motherID.value = checkData[0]["mother"]["id"].toString();
          selectFatherController.nameMother.value = "${checkData[0]["mother"]["name"].toString()} ${checkData[0]["mother"]["surname"].toString()}";
          selectFatherController.imageMother.value = checkData[0]["mother"]["profile_img"].toString();
          get.value = false;
          addMemberController.lastName.update((val) {
            addMemberController.lastName.value.dropDownValue = DropDownValueModel(
              name: checkData[0]["surname"],
              value: checkData[0]["surname"],
            );
          },);
          addMemberController.refresh();
        }
        else{
          get.value = false;
          print("error msg ${responseData["errorMsg"]}");
        }
      }
      else{
        get.value = false;
        print("status code ${response.statusCode}");
      }
    }
    catch(error){
      get.value = false;
      print("check member error ${error.toString()}");
    }
    finally{
      get.value = false;
    }
  }

  /// home add
  Future<bool> homeAdd() async{
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
      Map<String,dynamic> home = {
        "profile_img" : imageFile(profileImage.value),
        "name" : name.text.trim(),
        "relation": appRadioButtonController.selectedRelation.value == 0
            ? "son"
            : appRadioButtonController.selectedRelation.value == 1
            ? "daughter"
            : appRadioButtonController.selectedRelation.value == 2
            ? "brother"
            : appRadioButtonController.selectedRelation.value == 3
            ? "sister"
            : "",
        "surname" : surname.dropDownValue!.value.toString(),
        "mobile_no" : mobileNo.text.trim(),
        "address" : address.text.trim(),
        "city" : city.text.trim(),
        "state" : state.text.trim(),
        "country" : county.text.trim(),
        "pincode" : pinCode.text.trim(),
      };

      print("Home Add ${home.toString()}");
      print(appRadioButtonController.selectedRelation.value == 0
          ? "son"
          : appRadioButtonController.selectedRelation.value == 1
          ? "daughter"
          : appRadioButtonController.selectedRelation.value == 2
          ? "brother"
          : appRadioButtonController.selectedRelation.value == 3
          ? "sister"
          : "",);
      print(appRadioButtonController.selectedRelation.value);

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.familyAddressUser}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token
        },
        body: jsonEncode(home),
      );
      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("home add success");
          ///home add
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  content: Container(
                    decoration: BoxDecoration(
                      color: appColors.selectedColor.value,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    ),
                    child: Padding(padding: EdgeInsetsGeometry.all(8),
                      child: Text("Address Added Successfully",style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                    ),
                  )));
          addMemberController.addApiCall.value = true;
          addMemberController.profileImage.value = "";
          addMemberController.number.clear();
          addMemberController.name.clear();
          addMemberController.lastName.value.dropDownValue = null;
          addMemberController.number.clear();
          addMemberController.dateOfBirth.clear();
          addMemberController.deathDate.clear();
          addMemberController.email.clear();
          addMemberController.bloodGroup.clear();
          addMemberController.subProfession.clear();
          addMemberController.businessEmail.clear();
          addMemberController.businessNumber.clear();
          addMemberController.businessAddress.clear();
          selectFatherController.nameFather.value = "";
          selectFatherController.nameMother.value = "";
          selectFatherController.selectedMotherNames.clear();
          selectFatherController.selectedFatherNames.clear();
          appRadioButtonController.selectedIndexMarital.value = 0;
          Get.back();
        }
        else{
          add.value = false;
          errorMsg.value = responseData["errorMsg"].toString();
          print(errorMsg.value);
        }
      }
      else{
        add.value = false;
        print(response.statusCode);
      }

      return false;
    }
    catch(error){
      add.value = false;
      print("Home Add Catch Error: $error");
      return false;
      add.value = false;
    }
    finally{
      add.value = false;
    }
  }

  ///home update
  Future<bool> homeUpdate() async{
    try{
      edit.value = true;

      Map<String,dynamic> home = {
        "address" : address.text.trim()
      };

      print("Home address update ${home.toString()}");

      final response = await http.put(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.familyAddressUser}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey,
          "Authorization" : ApiUrl.token
        },
        body: jsonEncode(home),
      );

      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          ///home update
          print("Home Update Address");
        }
        else{
          edit.value = false;
          errorMsg.value = responseData["errorMsg"].toString();
          print(errorMsg.value);
        }
      }
      else{
        edit.value = false;
        print(response.statusCode);
      }

      return false;
    }
    catch(error){
      edit.value = false;
      print("Home Add Catch Error: $error");
      return false;
    }
    finally{
      edit.value = false;
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
}


class AddressModel {
  final String name;
  final String mobile;
  final String relation;

  AddressModel({
    required this.name,
    required this.mobile,
    required this.relation,
  });
}
