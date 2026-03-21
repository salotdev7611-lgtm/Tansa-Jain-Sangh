import 'dart:async';
import 'package:family_app/DesignScreen/HS/HomeAdd/Home_Add_Controller.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Bottom_Nav_Bar.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Bottom_Nav_Bar_Drawer.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/Home_Screen_User.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/OTP_Screen.dart';
import 'package:family_app/Helpers/api_url.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/DesignScreen/HS/HomeScreen/home_screen.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  final AppColors appColors = Get.put(AppColors());
  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final HomeAddController homeAddController = Get.put(HomeAddController());

  late AnimationController imageController;
  late Animation<Offset> imageAnimation;

  late AnimationController logoController;
  late Animation<double> logoScale;
  late Animation<double> logoFade;

  String fullText = "Tree";
  String visibleText = "";
  int letterIndex = 0;

  int second = 30;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // IMAGE SLIDE ANIMATION
    imageController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    imageAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 25), end: Offset(0, 8))
              .chain(CurveTween(curve: Curves.fastOutSlowIn)),
          weight: 33),
      TweenSequenceItem(tween: ConstantTween(Offset(0, 5)), weight: 33),
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 5), end: Offset(0, 0))
              .chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 33),
    ]).animate(imageController);

    // LOGO FADE & SCALE ANIMATION
    logoController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );

    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeIn),
    );


    imageController.addListener(() {
      listner();
    });
    imageController.forward().whenComplete(() {});
  }

  void otpTimer() {
    if(loginScreenController.sendOtp.value == true){
      print("timer start");
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (second != 0) {
          setState(() {
            second--;
          });
        } else {
          setState(() {
            enableResend = true;
          });
        }
      });
    }
  }

  void listner() {
    final progres = imageController.value;
    if (progres >= 0.33 && progres <= 0.66) {
      startTypingAnimation();
    }
  }

  bool typingStart = false;

  void startTypingAnimation() {
    if (!typingStart) {
      Future.delayed(const Duration(milliseconds: 0), () {
        revealNextLetter();
      });
    }
    typingStart = true;
  }

  void revealNextLetter() {
    if (letterIndex < fullText.length) {
      setState(() {
        visibleText += fullText[letterIndex];
        letterIndex++;
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        revealNextLetter();
      });
    } else {
      logoController.forward(); // start logo animation
    }
  }

  void _resendCode() {
    //other code here
    setState((){
      second = 30;
      enableResend = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    imageController.dispose();
    logoController.dispose();
    super.dispose();
  }

  final Color focusedBorderColor = const Color(0xFF0F5D5E);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (visibleText.length == fullText.length)
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: logoFade,
                      child: Image.asset(
                        'assets/images/login_tree.png',
                        fit: BoxFit.cover,
                        color: AppColors.white.withOpacity(0.09),
                        colorBlendMode: BlendMode.dstATop,
                      ),
                    ),
                  ),


                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      visibleText.length == fullText.length
                          ? FadeTransition(
                        opacity: logoFade,
                        child: ScaleTransition(
                          scale: logoScale,
                          child: Image.asset(
                            ApiUrl.appLogo,
                            height: 110,
                            width: 110,
                          ),
                        ),
                      )
                          : const SizedBox(height: 110),

                      const SizedBox(height: 20),

                      SlideTransition(
                        position: imageAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "FAM",
                              style: GoogleFonts.koHo(
                                height: 0.8,
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: visibleText.isEmpty
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                visibleText,
                                style: GoogleFonts.koHo(
                                  height: 0.8,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 22.h),

                      Obx(() => Visibility(
                        visible: loginScreenController.sendOtp.value,
                        child: Text(
                          "Verification",
                          style: GoogleFonts.koHo(
                            color: AppColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),),
                     Obx(() =>  Visibility(
                       visible: loginScreenController.sendOtp.value,
                       child: RichText(
                           text: TextSpan(
                               children: [
                                 TextSpan(
                                     text: "Send OTP To This Number ",
                                     style: Theme.of(context).textTheme.bodyRegular.copyWith(color: AppColors.text)
                                 ),
                                 TextSpan(
                                   text : loginScreenController.mobNo.value,
                                   style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),
                                 ),
                               ]
                           )
                       ),
                     ),),
                     Obx(() =>  Visibility(
                       visible: loginScreenController.sendOtp.value,
                       child: GestureDetector(
                           onTap: (){
                             loginScreenController.number.clear();
                             loginScreenController.sendOtp.value = false;
                             loginScreenController.pinController.clear();
                             loginScreenController.numberCheck.value = true;
                           },
                           child: Text("Change The Number ? ",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.red),))
                     ),),
                      if (visibleText.length == fullText.length)
                        FadeTransition(
                          opacity: logoFade,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Obx(() => Column(
                              children: [
                                Visibility(
                                  visible: loginScreenController.numberCheck.value,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.black.withOpacity(0.08),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(height: 10,),
                                        Form(
                                          key: loginScreenController.numberKey,
                                          child: TextFormField(
                                            style: Theme.of(context).textTheme.body1Regular,
                                            controller: loginScreenController.number,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 10,
                                            onChanged: (value) {
                                              if (value.length == 10) {
                                                FocusScope.of(context).unfocus(); // 🔥 closes keyboard
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please Enter Mobile Number';
                                              }
                                              if (value.length != 10) {
                                                return 'Mobile number must be 10 digits';
                                              }
                                              return null;
                                            },

                                            decoration: InputDecoration(
                                              hintText: "Mobile Number",
                                              counterText: '',
                                              prefixIcon: Icon(Icons.phone_android,
                                                  color: appColors.selectedColor.value),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50),
                                                borderSide: BorderSide(color: appColors.selectedColor.value),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50),
                                                borderSide: BorderSide(color: appColors.selectedColor.value),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50),
                                                borderSide: BorderSide(color: AppColors.red),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50),
                                                borderSide: BorderSide(color: AppColors.red),
                                              ),
                                              errorStyle: Theme.of(context)
                                                  .textTheme
                                                  .body2Regular
                                                  .copyWith(color: AppColors.red),
                                            ),
                                          ),),

                                        const SizedBox(height: 24),

                                        GestureDetector(
                                          onTap: () async{
                                            if(loginScreenController.numberKey.currentState!.validate()){

                                              await loginScreenController.loginApi();
                                              otpTimer();

                                            }
                                          },
                                          child: Container(
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: appColors.selectedColor.value,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Send OTP",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Visibility(
                                  visible: loginScreenController.sendOtp.value,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.black.withOpacity(0.08),
                                          blurRadius: 18,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child:  Column(
                                      children: [
                                        Form(
                                          key: loginScreenController.otpKey,
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Pinput(
                                              controller: loginScreenController.pinController,
                                              focusNode: loginScreenController.focusNode,
                                              length: 6,
                                              closeKeyboardWhenCompleted: false,
                                              keyboardType: TextInputType.number,
                                              animationDuration: Duration.zero,
                                              pinAnimationType: PinAnimationType.none,
                                              showCursor: true,
                                              separatorBuilder: (_) => const SizedBox(width: 10),

                                              /// 🔹 Validation
                                              validator: (otp) {
                                                if (otp == null || otp.isEmpty || otp.length < 6) {
                                                  return "Please enter valid OTP";
                                                }
                                                return null;
                                              },

                                              /// 🔹 When Completed
                                              onCompleted: (pin) {
                                                FocusScope.of(context).unfocus();
                                                debugPrint("OTP Entered: $pin");
                                              },

                                              /// 🔹 Default Theme
                                              defaultPinTheme: defaultPinTheme,

                                              /// 🔹 Focused Theme
                                              focusedPinTheme: defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme.decoration!.copyWith(
                                                  color: Colors.transparent,
                                                  border: Border.all(color: focusedBorderColor, width: 1.5),
                                                ),
                                              ),

                                              /// 🔹 Submitted Theme
                                              submittedPinTheme: defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme.decoration!.copyWith(
                                                  color: Colors.transparent,
                                                  border: Border.all(color: focusedBorderColor),
                                                ),
                                              ),

                                              /// 🔹 Error Theme
                                              errorPinTheme: defaultPinTheme.copyWith(
                                                decoration: defaultPinTheme.decoration!.copyWith(
                                                  color: Colors.transparent,
                                                  border: Border.all(color: Colors.redAccent),
                                                ),
                                              ),

                                              /// 🔹 Custom Cursor (Bottom Line Style)
                                              cursor: Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  width: 20,
                                                  height: 2,
                                                  margin: const EdgeInsets.only(bottom: 8),
                                                  color: focusedBorderColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        second == 0?
                                            SizedBox()
                                            : Text(
                                              '00 : $second',
                                              style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.facebookButton),
                                            ),
                                        second == 0 ?GestureDetector(
                                            onTap: (){
                                              loginScreenController.resendOtp();
                                              _resendCode();
                                              otpTimer();
                                            },
                                            child: Text("Resend OTP",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.facebookButton),)) : SizedBox(),
                                        SizedBox(height: 30),
                                        InkWell(
                                          onTap: () async {
                                            if(loginScreenController.otpKey.currentState!.validate()){
                                              await loginScreenController.otpApi();
                                              loginScreenController.numberCheck.value = true;
                                              loginScreenController.sendOtp.value = false;
                                              homeAddController.checkMember();
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
                            ),)
                          ),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


///button are comment...
// InkWell(
//   onTap: (){
//     loginScreenController.addVidhi.value = true;
//     Get.offAll(BottomNavBar(),transition: Transition.fadeIn,duration: Duration());
//   },
//   child: Container(
//     height: 50,
//     width: 320,
//     decoration: BoxDecoration(
//       color: AppColors.white,
//       border: Border.all(
//           color: AppColors.text,
//           width: 1
//       ),
//       borderRadius: BorderRadius.circular(100),
//     ),
//     child: Row(
//       spacing: 12,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SvgPicture.string(AppSvgs.googleLogo),
//         Text("Login with google",style: GoogleFonts.nunito(
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//           color: AppColors.text,
//         ),)
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: (){
//     loginScreenController.addVidhi.value = false;
//     Get.offAll(BottomNavBarDrawer(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
//     // Get.offAll(HomeScreen(),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
//   },
//   child: Container(
//     height: 50,
//     width: 320,
//     decoration: BoxDecoration(
//       color: AppColors.text,
//       borderRadius: BorderRadius.circular(100),
//     ),
//     child: Row(
//       spacing: 12,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SvgPicture.string(AppSvgs.apple,color: AppColors.white,),
//         Text("Login with Apple",style: GoogleFonts.nunito(
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//           color: AppColors.white,
//         ),)
//       ],
//     ),
//   ),
// ),
// InkWell(
//   onTap: (){
//     Get.offAll(AdminHomeScreen(),transition: Transition.fadeIn,duration: Duration());
//   },
//   child: Container(
//     height: 50,
//     width: 320,
//     decoration: BoxDecoration(
//       color: AppColors.facebookButton,
//       borderRadius: BorderRadius.circular(100),
//     ),
//     child: Row(
//       spacing: 12,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SvgPicture.string(AppSvgs.facebook,color: AppColors.white,),
//         Text("Login with Facebook",style: GoogleFonts.nunito(
//           fontWeight: FontWeight.w700,
//           fontSize: 16,
//           color: AppColors.white,
//         ),)
//       ],
//     ),
//   ),
// ),