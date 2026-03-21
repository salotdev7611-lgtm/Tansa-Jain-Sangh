import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreatePostCard extends StatefulWidget {
  const CreatePostCard({super.key});

  @override
  State<CreatePostCard> createState() => _CreatePostCardState();
}

class _CreatePostCardState extends State<CreatePostCard> {
  final AppColors appColors =  Get.put(AppColors());
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appColors.selectedColor.value),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  CircleAvatar(
                    radius: 22.5,
                    backgroundImage: AssetImage('assets/images/person.jpg'),
                  ),
                  Expanded(
                    child: Text(
                      "John Doe",
                      style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
                    ),
                  ),
                  SvgPicture.string(AppSvgs.closeCircle,width: 30,height: 30,colorFilter: ColorFilter.mode(AppColors.red, BlendMode.srcIn),)
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 5,
                    style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      border: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Write your post or question here",
                      hintStyle: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.grey),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ActiveButton(
                    onTap: () {

                    },
                    text: "Post"
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
