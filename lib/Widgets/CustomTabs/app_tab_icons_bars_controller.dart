import 'package:get/get.dart';

class AppTabBarIconsController extends GetxController{
  RxInt selectedIndex = 0.obs;
  RxInt selectedTwoIndex = 0.obs;

  changeIndex(index){
    selectedIndex.value = index;
    selectedTwoIndex.value = index;
  }
}