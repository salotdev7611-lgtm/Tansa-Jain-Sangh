import 'dart:convert';

import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Bottom_Nav_Bar.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Bottom_Nav_Bar_Drawer.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/LoginScreen.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:device_platform_uid/device_id.dart';
import '../../../Helpers/api_url.dart';
import '../../../Helpers/app_colors.dart';
import '../HomeAdd/Home_Add.dart';
import '../HomeScreen/Admin_Home_Screen_controller.dart';
import 'OTP_Screen.dart';

class LoginScreenController extends GetxController {

  final AddVidhiController addVidhiController = Get.put(AddVidhiController());
  AppColors appColors = Get.put(AppColors());
  RxBool addVidhi = false.obs;
  GlobalKey<FormState> numberKey = GlobalKey();
  TextEditingController number = TextEditingController();
  RxBool login = false.obs;
  RxBool loading = false.obs;
  RxString errorMsg = "".obs;
  RxString sessionID = "".obs;
  RxString deviceId = "".obs;
  RxBool numberCheck = true.obs;
  RxBool sendOtp = false.obs;
  RxString mobNo = "".obs;
  RxMap<String, dynamic> user = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> checkData = <Map<String, dynamic>>[].obs;


  RxString userId = "".obs;
  RxString profileImg = "".obs;
  RxString userName = "".obs;
  RxString address = "".obs;
  RxString phoneNumber = "".obs;
  RxString profession = "".obs;
  RxString maritalStatus = "".obs;
  RxString dateOfBirth = "".obs;
  RxString role = "".obs;
  RxString houseId = "".obs;
  RxBool get = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    deviceIDCheck();
  }

  void deviceIDCheck() async {
    deviceId.value = (await DeviceId().getDeviceId()) ?? "";
    print("deviceId: ${deviceId.value}");
  }
  Future<void> checkLoginStatus() async {
    try {

      print("start");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ApiUrl.token = prefs.getString("token") ?? "";

      print("ApiUrl.token ${ApiUrl.token}");

      if (ApiUrl.token.isEmpty) {
        // Get.to(LoginScreen());
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.userStatus}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );

      print("Status Code: ${response.statusCode}");
      print("api");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true){
          print("1 asjhdkajdhaksdhakd");
          final userData = responseData["data"][0];
          print("2");
          AppColors appColors = Get.put(AppColors());
          AddVidhiController addVidhiController = Get.put(AddVidhiController());
          AdminSettingController adminSettingController = Get.put(AdminSettingController());
          AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());
          print("3");
          userName.value = "${userData["name"]} ${userData["surname"]}";
          profileImg.value = userData["profile_img"].toString();
          userId.value = userData["id"].toString();
          address.value = "${userData["family_house_id"]["address"]}, ${userData["family_house_id"]["city"]}, ${userData["family_house_id"]["state"]},  ${userData["family_house_id"]["country"]},  ${userData["family_house_id"]["pincode"]}";
          phoneNumber.value = userData["mobile_no"].toString();
          profession.value = userData["profession"].toString();
          maritalStatus.value = userData["husband_wife_of"] == null ? "unmarried" : "married";
          dateOfBirth.value = userData["dob"].toString();
          role.value = userData["role"].toString();
          houseId.value = userData["family_house_id"]["id"].toString();

          print("4");
          if (userData["role"] == "Admin") {
            Get.offAll(AdminBottomNavBar(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          } else if (userData["role"] == "User"){
            Get.offAll(BottomNavBarDrawer(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          }
          print("5");
          final userRole = userData["role"].toString().toLowerCase();
          print("User role: $userRole");
          print("User role value: ${role.value}");

          final colorCode = userData["color_code"];
          print("colorCode ${colorCode}");

          final postValue  = userData["enable_posts"];
          print("post value ${postValue}");

          adminSettingController.post.value = postValue;
          print("adminSettingController.post.value ${adminSettingController.post.value}");

          final chat = userData["enable_chat"];
          adminSettingController.status.value = chat;

          final payment = userData["enable_payments"];
          adminSettingController.payment.value = payment;

          final surname = userData["surname"];
          addVidhiController.userSurname.value = surname;

          print("addVidhiController.userSurname.value ${addVidhiController.userSurname.value}");

          appColors.selectedColor.value = adminSettingController.hexToColor(colorCode);
          print("appColors.selectedColor.value ${appColors.selectedColor.value}");

          final name = "${userData["name"]} ${userData["surname"]}";
          adminHomeScreenController.userName.value = name;

          final image = userData["profile_img"];
          adminHomeScreenController.profile.value = image;

          final id = userData['id'];
          adminHomeScreenController.userId.value = id;

          // final colorCode = userData["color_code"];

          appColors.selectedColor.value = adminSettingController.hexToColor(colorCode);
          adminSettingController.getProfession();

        }
      }

    } catch (e) {
      print("loginStatus error: $e");
      // Get.offAll(LoginScreen());
    }
  }
  Future<void> profileStatus() async {
    try {

      get.value = true;
      print("start");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      ApiUrl.token = prefs.getString("token") ?? "";

      print("ApiUrl.token ${ApiUrl.token}");

      if (ApiUrl.token.isEmpty) {
        // Get.to(LoginScreen());
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.userStatus}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": ApiUrl.xApikey,
          "Authorization": ApiUrl.token,
        },
      );


      print("${ApiUrl.token}");
      print("Status Code: ${response.statusCode}");
      print("api");
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true){
          checkData.value = List<Map<String,dynamic>>.from(responseData["data"]);
          print("check data ${checkData.value}");
          get.value = false;
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

    } catch (e) {
      get.value = false;
      print("loginStatus error: $e");
      // Get.offAll(LoginScreen());
    }
    finally{
      get.value = false;
    }
  }

  Future<void> loginApi() async {
    try{
      login.value = true;

      Map<String,dynamic> loginNumber = {
        "mobile_no" : number.text.trim(),
        "device_id" : deviceId.value
      };

      debugPrint("data $loginNumber");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.login}"),
        headers: {
          "Content-Type": "application/json",
          "x-api-key" : ApiUrl.xApikey
        },
        body: jsonEncode(loginNumber),
      );

      print(response.body);

      print(response.statusCode);
      if(response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true) {
          ///login successfully
          print("Success api responds");
          numberCheck.value = false;
          sendOtp.value = true;
          mobNo.value = number.text;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          sessionID.value = responseData["request_otp_token"].toString();
          await prefs.setString("request_otp_token", sessionID.value.toString());

          print("request_otp_token ${sessionID.value}");
          mobNo.value = number.text;
          // Get.offAll(OtpScreen(number: number.text,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));

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
                    child: Padding(padding: EdgeInsetsGeometry.all(8),
                      child: Text("Send OTP",style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                    ),
                  )));
        }

        else{
          login.value = false;
          errorMsg.value = responseData["errorMsg"];
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Error",style: Theme.of(Get.context!).textTheme.bodyBold.copyWith(color: AppColors.white),),
                          Text(errorMsg.value,style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                        ],
                      ),
                    ),
                  )));
          print("Error Msg ${errorMsg.value}");
        }
      }
      else{
        login.value = false;
        print("response Code ${response.statusCode}");
      }

    }
    catch(error) {
      login.value = false;
      print("Catch Error ${error.toString()}");
    }
    finally{
      login.value = false;
    }
  }

  TextEditingController pinController = TextEditingController();

  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> otpKey = GlobalKey();

  RxString token = "".obs;

  RxBool otp = false.obs;
  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  Future<bool> otpApi() async {
    try{
      otp.value = true;

      Map<String,dynamic> otpNumber = {
        "otp_token" : sessionID.value,
        "otp" : pinController.text.trim()
      };

      debugPrint("otpNumber: $otpNumber");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.otp}"),
        headers: {
          "Content-Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey
        },
        body: jsonEncode(otpNumber),
      );

      final responseData = jsonDecode(response.body);

      print("Body ${response.body}");
      print("map ${responseData.toString()}");

      if(response.statusCode == 200){

        if(responseData["success"] == true){

          print("----------- Success api responds -----------");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          token.value = responseData["token"].toString();
          await prefs.setString("token", token.value.toString());
          print("token ${token.value}");
          ApiUrl.token = token.value;


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
                    child: Padding(padding: EdgeInsetsGeometry.all(8),
                      child: Text("Verify OTP",style: Theme.of(Get.context!).textTheme.body1Bold.copyWith(color: AppColors.white),),
                    ),
                  )));

          Get.offAll(AddMemberUser(),transition: Transition.fadeIn,duration: Duration(milliseconds: 300));
          otp.value = false;
          return true;
        }
        else{
          otp.value = false;
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

          return false;
        }
      }

      else{
        otp.value = false;
        print("status code ${response.statusCode}");
        return false;
      }
    }
    catch(error){
      print("OTP Catch Error: $error");
      return false;

    }
  }
  ///resend otp
  Future<bool> resendOtp() async{
    try{

      Map<String,dynamic> otp = {
        "otp_token" : sessionID.value,
        "device_id" : deviceId.value,
      };

      print("resend OTP ${otp}");

      final response = await http.post(
        Uri.parse("${ApiUrl.baseUrl}${ApiUrl.resendOtp}"),
        headers: {
          "Content -Type" : "application/json",
          "x-api-key" : ApiUrl.xApikey
        },
        body: jsonEncode(otp),
      );

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        if(responseData["success"] == true){
          print("------ resend otp successfully ------");
        }
        else{
          print("error msg ${responseData["errorMsg"]}");
        }
      }
      else{
        print("status code ${response.statusCode}");
      }
      return false;
    }
    catch(error){
      print("catch error ${error}");
      return false;
    }
  }

  Future<void> logOut() async {
    ApiUrl.token = "";
    number.clear();
    pinController.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => LoginScreen(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
  }


}
