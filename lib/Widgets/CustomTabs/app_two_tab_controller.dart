import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppTwoTabController extends GetxController {
  RxInt selectedTwoIndex = 0.obs;

  changeIndex(index){
    selectedTwoIndex.value = index;
  }
}