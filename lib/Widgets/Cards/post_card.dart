import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Helpers/app_colors.dart';

// ignore: must_be_immutable
class PostCard extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onBookMark;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final String date;
  bool? isLiked;
  bool? isBookMarked;
  PostCard({super.key, required this.onTap, required this.onBookMark, required this.onLike, required this.onComment, this.isLiked, this.isBookMarked, required this.date});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  final AppColors appColors = Get.put(AppColors());

  String getTimeDifferenceAsString(String pastDateTimeStr) {
    DateTime pastTime = DateTime.parse("${pastDateTimeStr}Z").toLocal();
    DateTime now = DateTime.now();
    Duration diff = now.difference(pastTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${pastTime.year}-${pastTime.month.toString().padLeft(2, '0')}-${pastTime.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: appColors.selectedColor.value.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: Offset(0, 0)
              )
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage("assets/images/person.jpg"),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            "Isabella Davis",
                            style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
                          ),
                          Text(
                            getTimeDifferenceAsString(widget.date),
                            style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.onBookMark;
                        setState(() {
                          widget.isBookMarked = !widget.isBookMarked!;
                        });
                      },
                        child: SvgPicture.string(
                          widget.isBookMarked == true
                              ? AppSvgs.bookMarkFilledStared
                              : AppSvgs.bookMarkOutlineStared,
                          width: 30,
                          height: 30,
                          colorFilter: ColorFilter.mode(
                              widget.isBookMarked == true
                                  ? appColors.selectedColor.value
                                  : appColors.selectedColor.value,
                              BlendMode.srcIn
                          ),
                        )
                    )
                  ],
                ),
                Text(
                  "Lorem ipsum dolor sit amet consectetur. Sed bibendum at mauris diam sed congue vestibulum ac. Blandit ut id consectetur tempor in nulla. Arcu purus risus quam eu faucibus pulvinar amet. Ultricies amet dictum vestibulum vitae pharetra egestas erat."
                      "Lorem ipsum dolor sit amet consectetur. Sed bibendum at mauris diam sed congue vestibulum ac. Blandit ut id consectetur tempor in nulla. Arcu purus risus quam eu faucibus pulvinar amet. Ultricies amet dictum vestibulum vitae pharetra egestas erat.",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.justify,
                ),
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onLike;
                        setState(() {
                          widget.isLiked = !widget.isLiked!;
                        });
                      },
                      child: Row(
                        spacing: 5,
                        children: [
                          SvgPicture.string(
                            widget.isLiked == true
                                ? AppSvgs.likeFilled
                                : AppSvgs.likeOutline,
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                widget.isLiked == true
                                ? AppColors.red
                                : appColors.selectedColor.value,
                                BlendMode.srcIn
                            ),
                          ),
                          Text(
                            "5",
                            style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.black),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onComment,
                      child: Row(
                        spacing: 5,
                        children: [
                          SvgPicture.string(AppSvgs.comment,width: 20,height: 20,colorFilter: ColorFilter.mode(appColors.selectedColor.value, BlendMode.srcIn),),
                          Text(
                            "3",
                            style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.black),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
