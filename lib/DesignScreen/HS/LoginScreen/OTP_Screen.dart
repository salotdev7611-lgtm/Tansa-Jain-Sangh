import 'package:family_app/DesignScreen/HS/HomeAdd/Home_Add.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/OTP_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.number});
  final String number;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final OtpController otpController = Get.put(OtpController());
  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    otpController.otpKey = GlobalKey<FormState>();
    otpController.pinController = TextEditingController();
    otpController.focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    otpController.pinController.dispose();
    otpController.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(width: 2, color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            /// ✅ BACKGROUND IMAGE (FIXED & CORRECT)
            Positioned.fill(
              child: Image.asset(
                'assets/images/login_tree.png',
                fit: BoxFit.cover,
                color: AppColors.white.withOpacity(0.09),
                colorBlendMode: BlendMode.dstATop,
              ),
            ),

            /// ✅ FOREGROUND CONTENT
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 6.h),

                    /// LOGO
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 110,
                        width: 110,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// SVG
                    SvgPicture.string(AppSvgs.famTree),

                    SizedBox(height: 2.h),

                    /// TITLE
                    Text(
                      "Verification",
                      style: GoogleFonts.koHo(
                        color: AppColors.text,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                   RichText(
                       text: TextSpan(
                         children: [
                           TextSpan(
                             text: "Send OTP To This Number ",
                             style: Theme.of(context).textTheme.bodyRegular.copyWith(color: AppColors.text)
                           ),
                           TextSpan(
                               text: widget.number,
                               style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
                           ),
                         ]
                       )
                   ),
                    SizedBox(height: 4.h),

                    /// OTP FORM
                    Form(
                      key: otpController.otpKey,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: otpController.pinController,
                          focusNode: otpController.focusNode,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (_) => const SizedBox(width: 8),
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            debugPrint('OTP Completed: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('OTP Changed: $value');
                          },
                          validator: (otp){
                            if(otp!.isEmpty || otp == null){
                              return "Please Enter Valid OTP";
                            }
                            return null;
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                            defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border:
                              Border.all(color: focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration:
                            defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(19),
                              border:
                              Border.all(color: focusedBorderColor),
                            ),
                          ),
                          errorPinTheme:
                          defaultPinTheme.copyBorderWith(
                            border:
                            Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),


                    InkWell(
                      onTap: () async {
                        // Get.offAll(HomeAdd(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                        if(otpController.otpKey.currentState!.validate()){
                          await otpController.otpApi();
                        }
                      },
                      child: Container(
                        height: 45,
                        width: 180,
                        decoration: BoxDecoration(
                          color: appColors.selectedColor.value,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("Verify",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
