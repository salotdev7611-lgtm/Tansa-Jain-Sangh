import 'dart:convert';
import 'package:family_app/DesignScreen/HS/HomeScreen/Admin_Home_Screen_controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/text_field_customization.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'DesignScreen/HS/HomeScreen/Admin_Bottom_Nav_Bar.dart';
import 'DesignScreen/HS/HomeScreen/Bottom_Nav_Bar.dart';
import 'DesignScreen/HS/HomeScreen/Bottom_Nav_Bar_Drawer.dart';
import 'DesignScreen/HS/HomeScreen/Home_Screen_Bottom.dart';
import 'DesignScreen/HS/HomeScreen/Home_Screen_User.dart';
import 'Helpers/api_url.dart';


bool isLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loginStatus();
  runApp(const MyApp());
}

Future<void> loginStatus() async {
  try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiUrl.token = prefs.getString("token") ?? "";

    print("ApiUrl.token ${ApiUrl.token}");

    if (ApiUrl.token.isEmpty) {
      // Get.to(LoginScreen());
      return;
    }

    final response = await http.get(
      Uri.parse("${ApiUrl.baseUrl}${ApiUrl.userStatus}"),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": ApiUrl.xApikey,
        "Authorization": ApiUrl.token,
      },
    );

    print("Status Code: ${response.statusCode}");

    if (response.statusCode != 200) {
      // Get.to(LoginScreen());
      return;
    }

    final responseData = jsonDecode(response.body);

    if (responseData["success"] != true || responseData["data"] == null || responseData["data"].isEmpty) {
      // Get.to(LoginScreen());
      return;
    }

    final userData = responseData["data"][0];

    LoginScreenController loginScreenController = Get.put(LoginScreenController());
    AppColors appColors = Get.put(AppColors());
    AddVidhiController addVidhiController = Get.put(AddVidhiController());
    AdminSettingController adminSettingController = Get.put(AdminSettingController());
    AdminHomeScreenController adminHomeScreenController = Get.put(AdminHomeScreenController());

    //  RxString address = "".obs;
    //   RxString phoneNumber = "".obs;
    //   RxString profession = "".obs;
    //   RxString maritalStatus = "".obs;
    //   RxString dateOfBirth = "".obs;

    loginScreenController.userName.value = "${userData["name"]} ${userData["surname"]}";
    loginScreenController.profileImg.value = userData["profile_img"].toString();
    loginScreenController.userId.value = userData["id"].toString();
    loginScreenController.address.value = "${userData["family_house_id"]["address"]}, ${userData["family_house_id"]["city"]}, ${userData["family_house_id"]["state"]},  ${userData["family_house_id"]["country"]},  ${userData["family_house_id"]["pincode"]}";
    loginScreenController.phoneNumber.value = userData["mobile_no"].toString();
    loginScreenController.profession.value = userData["profession"].toString();
    loginScreenController.maritalStatus.value = userData["husband_wife_of"] == null ? "unmarried" : "married";
    loginScreenController.dateOfBirth.value = userData["dob"].toString();
    loginScreenController.role.value = userData["role"].toString();
    loginScreenController.houseId.value = userData["family_house_id"]["id"];


    final userRole = userData["role"].toString().toLowerCase();
    print("User role: $userRole");
    print("User role: ${loginScreenController.role.value}");

    final colorCode = userData["color_code"];
    print("colorCode ${colorCode}");

    final postValue  = userData["enable_posts"];
    print("post value ${postValue}");

    adminSettingController.post.value = postValue;
    print("adminSettingController.post.value ${adminSettingController.post.value}");

    final chat = userData["enable_chat"];
    adminSettingController.status.value = chat;

    final payment = userData["enable_payments"];
    adminSettingController.payment.value = payment;

    final surname = userData["surname"];
    addVidhiController.userSurname.value = surname;

    print("addVidhiController.userSurname.value ${addVidhiController.userSurname.value}");

    appColors.selectedColor.value = adminSettingController.hexToColor(colorCode);
    print("appColors.selectedColor.value ${appColors.selectedColor.value}");

    final name = "${userData["name"]} ${userData["surname"]}";
    adminHomeScreenController.userName.value = name;

    final image = userData["profile_img"];
    adminHomeScreenController.profile.value = image;

    final id = userData['id'];
    adminHomeScreenController.userId.value = id;

    // final colorCode = userData["color_code"];

    appColors.selectedColor.value = adminSettingController.hexToColor(colorCode);
    adminSettingController.getProfession();


    /// ✅ ROLE BASED SCREEN (NO GET NAV HERE)
    if (userRole == "Admin") {
     // Get.offAll(AdminBottomNavBar());
    } else {
      // HomeScreen();
    }

  } catch (e) {
    print("loginStatus error: $e");
    // Get.offAll(LoginScreen());
  }
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) => GetMaterialApp(
        title: 'Family App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          inputDecorationTheme: TextFieldDecoration.inputDecorationTheme,
        ),
        /*home: Scaffold(
          body: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                CreatePostCard(),
              ],
            ),
          ),
        ),*/
        home: ApiUrl.token.isNotEmpty && loginScreenController.houseId.value.isNotEmpty ? loginScreenController.role == "Admin" ? AdminBottomNavBar() : BottomNavBarDrawer() : LoginScreen(),
        // home: ApiUrl.token.isNotEmpty ? HomeScreen() : LoginScreen(),
        // home: ApiUrl.token.isNotEmpty ? BottomNavBar() : LoginScreen(),
        // home: ApiUrl.token.isNotEmpty ? BottomNavBarDrawer() : LoginScreen(),
        // home: ApiUrl.token.isNotEmpty ? HomeScreenUser() : LoginScreen(),
      ),
    );
  }
}

