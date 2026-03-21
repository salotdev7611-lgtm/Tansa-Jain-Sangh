import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppTabSurnameController extends GetxController {
  RxInt selectedIndex = 0.obs;

  changeIndex(index){
    selectedIndex.value = index;
  }
}