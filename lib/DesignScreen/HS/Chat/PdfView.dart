import 'dart:async';
import 'package:family_app/DesignScreen/HS/Chat/Chat_Screen_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Helpers/app_svgs.dart';

class Pdfview extends StatefulWidget {
  final String filePath;
  final String fileName;

  const Pdfview({
    super.key,
    required this.filePath, required this.fileName,
  });

  @override
  State<Pdfview> createState() => _PdfviewState();
}

class _PdfviewState extends State<Pdfview> {

  final Completer<PDFViewController> _controller = Completer();

  int? pages;
  bool isReady = false;
  final ChatScreenController chatScreenController = Get.put(ChatScreenController());
  bool send = false;
  final AppColors appColors = Get.put(AppColors());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(widget.fileName,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: PDFView(
                filePath: widget.filePath,
                enableSwipe: true,
                swipeHorizontal: false, // ✅ Vertical scroll
                autoSpacing: true,      // Better page spacing
                pageFling: true,
                pageSnap: true,
                backgroundColor: AppColors.white,
                onRender: (_pages) {
                  setState(() {
                    pages = _pages;
                    isReady = true;
                  });
                },
                onError: (error) {
                  debugPrint(error.toString());
                },
                onPageError: (page, error) {
                  debugPrint('$page: $error');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _controller.complete(pdfViewController);
                },
                onPageChanged: (int? page, int? total) {
                  debugPrint('page change: $page/$total');
                },
              ),
            ),
            if (!isReady)
              const Center(
                child: CircularProgressIndicator(),
              ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: AppColors.white,
                    elevation: 4,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          send = value.isNotEmpty;
                        });
                      },
                      controller: chatScreenController.messageController,
                      decoration: InputDecoration(
                        hintText: "Type a Message...",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .body2Regular
                            .copyWith(color: AppColors.text),
                        filled: true,
                        fillColor: AppColors.white,

                        // Border settings
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: AppColors.grey, width: 1),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    final text = chatScreenController.messageController.text.trim();
                    if (text.isEmpty) return;

                    chatScreenController.messages.add({
                      "text": text,
                      "isMe": true,
                      "time": DateFormat("hh:mm a").format(DateTime.now()),
                    });
                    chatScreenController.sendMessage(
                      chatScreenController.pdfMemberId.value,
                      chatScreenController.pdfGroupId.value,
                    );
                    // chatScreenController.messageController.clear();
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.selectedColor.value
                    ),
                    child: Center(
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: SvgPicture.string(AppSvgs.send)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,)

          ],
        ),
      ),
    );
  }
}
