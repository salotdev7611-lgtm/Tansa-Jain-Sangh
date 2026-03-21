import 'package:get/get.dart';

class AppRadioButtonController extends GetxController{
  RxInt selectedIndexGender = 0.obs;
  RxInt selectedIndexMarital = 0.obs;
  RxInt selectedRelation = 0.obs;

  changeIndex(index){
    selectedIndexGender.value = index;
    selectedIndexMarital.value = index;
    selectedRelation.value = index;
  }
}