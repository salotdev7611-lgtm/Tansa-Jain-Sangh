import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Helpers/app_svgs.dart';
import '../Buttons/outline_button.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    super.key,
    required this.title,
    required this.description,
    required this.yesOnTap,
  });

  final String title;
  final String description;
  final VoidCallback yesOnTap;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // prevents overflow
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Title Row
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyBold!
                          .copyWith(color: AppColors.text),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.back();
                      },
                      child: SvgPicture.string(
                        AppSvgs.closeCircle,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .body1Regular!
                      .copyWith(color: AppColors.grey),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(onTap: (){
                      Get.back();
                      Get.back();
                      },
                        borderColor: AppColors.red,
                        text: "No, Never", icon: ""),

                    ActiveButton(onTap: widget.yesOnTap, text: "Yes, Delete"),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /// This widget displays nothing — it only triggers the dialog.
    return const SizedBox.shrink();
  }
}
