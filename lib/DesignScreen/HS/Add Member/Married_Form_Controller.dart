import 'dart:convert';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../../Helpers/app_colors.dart';

class MarriedFormController extends GetxController {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());


  RxString profileImage = "".obs;

  RxBool add = false.obs;
  RxBool edit = false.obs;

}