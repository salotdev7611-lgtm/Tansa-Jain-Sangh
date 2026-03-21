import 'package:family_app/DesignScreen/HS/ContactsDetails/Add_Contacts_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  const ActiveButton({super.key, required this.onTap, required this.text, this.textStyle, this.height, this.width});

  @override
  State<ActiveButton> createState() => _ActiveButtonState();
}

class _ActiveButtonState extends State<ActiveButton> {

  final AppColors appColors = Get.put(AppColors());
  final AddContactsController addContactsController = Get.put(AddContactsController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: appColors.selectedColor.value,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          child: Center(
            child: addContactsController.add.value
                ? CircularProgressIndicator()
                :Text(widget.text,
              style: widget.textStyle ?? Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
