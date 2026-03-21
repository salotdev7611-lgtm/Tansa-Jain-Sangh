import 'dart:convert';

import 'package:family_app/DesignScreen/HS/LoginScreen/LoginScreen.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Helpers/app_colors.dart';
import '../../../TextTheme/text_theme.dart';
import '../HomeAdd/Home_Add.dart';

class OtpController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  final AppColors appColors = Get.put(AppColors());
  TextEditingController pinController = TextEditingController();

  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> otpKey = GlobalKey();

  RxString token = "".obs;

  RxBool otp = false.obs;

  Future<bool> otpApi() async {
    try{
      otp.value = true;

      Map<String,dynamic> otpNumber = {
        "otp_token" : loginScreenController.sessionID.value,
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

      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);

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

          Get.offAll(HomeAdd(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
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
}