import 'package:get/get.dart';

class AppSwitchController extends GetxController{
  RxBool isEnabled = false.obs;

  changeBool(bool value){
    isEnabled.value = value;
  }
}