import 'package:family_app/Helpers/app_colors.dart';
import 'package:flutter/material.dart';

class TextFieldDecoration{
  BuildContext context;
  TextFieldDecoration(this.context);
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryGreen,width: 1),
      ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.text,width: 1),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.text,width: 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.text,width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.red,width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: AppColors.red,width: 1),
    ),
  );
}