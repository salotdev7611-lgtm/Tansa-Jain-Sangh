import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Admin_Setting/Admin_Setting_Controller.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Buttons/active_button.dart';
import 'package:family_app/Widgets/Buttons/active_icon_button.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_bars.dart';
import 'package:family_app/Widgets/CustomTabs/app_tab_surname.dart';
import 'package:family_app/Widgets/TextFormFields/app_searchbar.dart';
import 'package:family_app/Widgets/vidhi/vidhi_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Helpers/app_colors.dart';
import 'Vidhi_Details.dart';

class Vidhi extends StatefulWidget {
  const Vidhi({super.key, required this.automaticallyImplyLeading});
  final bool automaticallyImplyLeading ;

  @override
  State<Vidhi> createState() => _VidhiState();
}

class _VidhiState extends State<Vidhi> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AddVidhiController addVidhiController = Get.put(AddVidhiController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addVidhiController.getVidhi(
        surname: addVidhiController.userSurname.value,
      );
    });
  print("addVidhiController.userSurname.value ${addVidhiController.userSurname.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Vidhi",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 12,
          children: [
            AppSearchbar(controller: addVidhiController.search,onChange: addVidhiController.runFilter,),
            SizedBox(
                height: 40,
                child: AppTabSurname(items: [], selectedIndex: 0)),
            
            Obx((){
              if(addVidhiController.get.value){
                return Center(child: CircularProgressIndicator());
              }
              if(addVidhiController.listOfVidhi.isEmpty){
                return Center(child: Text("No Vidhi Add In This Surname"),);
              }
              else{
                return Expanded(
                  child: ListView.builder(
                    itemCount: addVidhiController.listOfVidhi.length,
                    itemBuilder: (context, index) {
                      final vidhi = addVidhiController.listOfVidhi[index];
                      return GestureDetector(
                        onTap: (){
                          Get.to(VidhiDetails(
                            id: vidhi["id"],
                            poster: vidhi["poster"],
                            title: vidhi["title"],
                            dateTime: vidhi["tithi_date"],
                            description: vidhi["description"],
                            poojaEssentials: List<String>.from(vidhi["pooja_essentials"]),
                            instruction: List<Map<String, dynamic>>.from(vidhi["detailed_description"],),
                            surname: DropDownValueModel(
                              name: vidhi["surname"],
                              value: vidhi["surname"],
                            ),                      ),   transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 100),);
                        },
                        child: VidhiContainer(
                          vidhiName: vidhi["title"],
                          date: vidhi["tithi_date"],
                          tithi: vidhi["tithi_date"],
                          description: vidhi["description"],
                        ),
                      );
                    },),
                );   
              }
            })
          ],
        ),
      ),

      floatingActionButton: Visibility(
        visible: loginScreenController.addVidhi.value,
          child: ActiveIconButton(onTap: (){
            Get.to(AddVidhi(id: '',),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
          }, text: "Add Vidhi", icon: AppSvgs.add)),
      // floatingActionButton: ActiveIconButton(onTap: (){}, text: "Add Vidhi", icon: AppSvgs.add)
    );
  }
}
