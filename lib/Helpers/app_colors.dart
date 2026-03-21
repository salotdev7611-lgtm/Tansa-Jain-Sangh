import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors extends GetxController {
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color text = Color(0xff1C2529);
  static const Color grey = Color(0xff697586);
  static const Color red = Color(0xffD70040);
  static const Color primaryGreen = Color(0xff2ECC71);
  static const Color greenShade = Color(0xffE8FFF2);
  static const Color facebookButton = Color(0xff1877F2);
  static const Color lightGrey = Color(0xffEEEEEE);
  final Rx<Color> selectedColor =  Color(0xFF085B66).obs;
  // static const Color buttonColor = Color(0xFF085B66);///star color
  // static const Color buttonColor = Color(0xFF440866);///star color -2
  // static const Color buttonColor = Color(0xFF550866);///star co lor -3
  // static const Color buttonColor = Color(0xFF0F9BAB);///
  // static const Color buttonColor = Color(0xFF660842);/// star color 4
  // static const Color buttonColor = Color(0xff14453D);
  // static const Color buttonColor = Color(0xff14453D);
  static const Color chatBubble = Color(0xffF2F2F7);
  static const Color lightGreen = Color(0xff34BF4C);
  static const Color opacity = Color(0xff1C25291A);
  static const Color comment = Color(0xff1C252905);

  static const Gradient backgroundGradient = LinearGradient(
      colors: [
        Color(0xffFFFFFF),
        Color(0xffF5FCF8),
      ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );

  static const BorderRadius radius = BorderRadius.all(Radius.circular(10.0));
}