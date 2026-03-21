import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/LoginScreen/Login_Screen_Controller.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi.dart';
import 'package:family_app/DesignScreen/HS/vidhi/Add_Vidhi_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/Helpers/app_svgs.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/Dilog/Delete_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VidhiDetails extends StatefulWidget {
  const VidhiDetails({super.key, required this.poster, required this.title, required this.dateTime, required this.description, required this.poojaEssentials, required this.instruction, required this.id, required this.surname});
  final String id;
  final String poster;
  final String title;
  final DropDownValueModel surname;
  final String dateTime;
  final String description;
  final List<dynamic> poojaEssentials;
  final List<Map<String,dynamic>> instruction;


  @override
  State<VidhiDetails> createState() => _VidhiDetailsState();
}

class _VidhiDetailsState extends State<VidhiDetails> {

  final LoginScreenController loginScreenController = Get.put(LoginScreenController());
  final AddVidhiController addVidhiController = Get.put(AddVidhiController());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
      top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: AppColors.white,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(widget.title,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
            actions: [
              Visibility(
                  visible: loginScreenController.addVidhi.value,
                  child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      addVidhiController.vidhiUpdate.value = true;
                      addVidhiController.vidhiImage.value = widget.poster;
                      addVidhiController.surname.dropDownValue = widget.surname;
                      addVidhiController.title.text = widget.title;
                      addVidhiController.tithiDate.text = widget.dateTime;
                       addVidhiController.description.text = widget.description;
                      addVidhiController.pujaEssentials.assignAll(widget.poojaEssentials.map((e) => TextEditingController(text: e.toString()),), );
                      addVidhiController.cookingTitle.assignAll(widget.instruction.map((e) => TextEditingController(text: e["title"].toString())));
                      addVidhiController.cookingDescription.assignAll(widget.instruction.map((e) => TextEditingController(text: e["description"].toString())));
                      Get.to(AddVidhi(id: widget.id,),transition: Transition.fadeIn,duration: Duration(milliseconds: 100));
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.string(
                          AppSvgs.editColored,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  InkWell(
                    onTap: () {
                      Get.dialog(Dialog(
                        child: DeleteDialog(title: "Delete Vidhi", description: "Are you sure you want to delete ‘${widget.title}’? ",
                          yesOnTap: () {
                          addVidhiController.deleteVidhi(context, id: widget.id);
                          },),
                      ));
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.string(
                          AppSvgs.deleteFilled,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                ],
              ))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.poster),
                  // Image.asset("assets/images/nivedCard.png"),
                  // SizedBox(height: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                      Text(widget.dateTime,style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                    ],
                  ),
                  Text(widget.description,style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),textAlign: TextAlign.justify,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     // Text("15 Sep, 2025",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                  //     // Text("Bhadrava Sud Nom",style: Theme.of(context).textTheme.body2Regular.copyWith(color: AppColors.text),),
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text("Purpose: ",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                  //     Expanded(child: Text("Offering food to the deity before consumption, symbolizing gratitude and purity.",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),)),
                  //   ],
                  // ),
                  // Text("When to Perform?",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  // title("Date:", "Mon, 15 Oct, 2025"),
                  // title("Special Days::", "Diwali (Kali Chaudas) & Navratri(8th Day)"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text("Pooja Essentials",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.poojaEssentials.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              spacing: 12,
                              children: [
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.black
                                  ),
                                ),
                                Text(widget.poojaEssentials[index],style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                              ],
                            ),
                          );
                        },),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text("Banava Ni Rit",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.instruction.length,
                itemBuilder: (context, index) {
                  final item = widget.instruction[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Bullet
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black,
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// Text
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .body1Regular
                                  .copyWith(color: AppColors.text),
                              children: [
                                TextSpan(
                                  text: "${item["title"]} : ",
                                  style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),
                                ),
                                TextSpan(
                                  text: item["description"] ?? "",
                                  style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   spacing: 6,
                  //   children: [
                  //     Text("Banava Ni Rit",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  //     ListView.builder(
                  //       padding: EdgeInsets.zero,
                  //       physics: NeverScrollableScrollPhysics(),
                  //       shrinkWrap: true,
                  //       itemCount: 5,
                  //       itemBuilder: (context, index) {
                  //         return Padding(
                  //           padding: const EdgeInsets.only(bottom: 4),
                  //           child: Row(
                  //             spacing: 12,
                  //             children: [
                  //               Container(
                  //                 height: 5,
                  //                 width: 5,
                  //                 decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     color: AppColors.black
                  //                 ),
                  //               ),
                  //               Text("Cooked food (Lapsi, Churma, sweets)",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                  //             ],
                  //           ),
                  //         );
                  //       },),
                  //   ],
                  // ),

                  // Text("Ritual Steps",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  // title("Purify Space:", "Light diya, incense. Clean the area."),
                  // title("Arrange Offering:", "Place food neatly on plate. Avoid tasting beforehand."),
                  // title("Invocation:", "Chant mantras or offer silent prayer to Kuldevi/Kuldevta."),
                  // title("Offer Naivedya:", "Present food with folded hands. Leave undisturbed for a few minutes."),
                  // title("Acceptance:", "After offering, consider the food blessed. Serve as prasad."),
                  // Text("Recipes Step",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SizedBox(
                  //         width: 100,
                  //         child: Text("Ingredients:",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),)),
                  //     Expanded(
                  //       child: ListView.builder(
                  //         padding: EdgeInsets.zero,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         shrinkWrap: true,
                  //         itemCount: 4,
                  //         itemBuilder: (context, index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.only(bottom: 4),
                  //             child: Row(
                  //               spacing: 12,
                  //               children: [
                  //                 Container(
                  //                   height: 5,
                  //                   width: 5,
                  //                   decoration: BoxDecoration(
                  //                       shape: BoxShape.circle,
                  //                       color: AppColors.black
                  //                   ),
                  //                 ),
                  //                 Text("${index== 0 ? "1cup Broken Wheat (Dalia)" : ""}${index == 1 ?"1 cup Jaggery, grated or powdered" : ""}${index==2? "2 tbsp Ghee" : ""}${index==3? "2 cups Hot Water": ""}",style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),),
                  //
                  //               ],
                  //             ),
                  //           );
                  //         },),
                  //     ),
                  //   ],
                  // ),
                  // Text("Cooking Instructions:",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                  // title("Prep Jaggery Syrup:", "Dissolve jaggery in hot water, strain to remove impurities, and set aside."),
                  // title("Roast Dalia:", "In another pan, heat 1 tbsp ghee. Add broken wheat and roast until aromatic and golden-orange."),
                  // title("Cook the Mixture:", "Pour in jaggery syrup and cardamom powder. Stir well. Cover and simmer on low heat for 10–15 minutes until wheat is tender."),
                  // title("Finish & Serve:", "Stir in roasted nuts and raisins. Let it rest for 5 minutes. Serve warm."),
                  // SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget title(String title,String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),
          ),
        ),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.body1Regular.copyWith(color: AppColors.text),
          ),
        ),
      ],
    );
  }

}
