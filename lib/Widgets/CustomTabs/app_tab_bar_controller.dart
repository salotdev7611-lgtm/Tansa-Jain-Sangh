import 'package:get/get.dart';

class AppTabBarController extends GetxController{
  RxInt selectedIndex = 0.obs;

  changeIndex(index){
    selectedIndex.value = index;
  }

}