import 'dart:io';

import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Select_Father_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:family_app/Widgets/TextFormFields/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../Helpers/app_svgs.dart';

class SelectFather extends StatefulWidget {
  const SelectFather({super.key});

  @override
  State<SelectFather> createState() => _SelectFatherState();
}

class _SelectFatherState extends State<SelectFather> {

  final AddMemberController addMemberController = Get.put(AddMemberController());
  final SelectFatherController selectFatherController = Get.put(SelectFatherController());
  final AppColors appColors = Get.put(AppColors());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectFatherController.search.value = true;
    selectFatherController.getParent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Select Father",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),

      actions: [
        GestureDetector(
          onTap: (){
            selectFatherController.selectedFatherNames.clear();
            selectFatherController.selectedFatherImages.clear();
            selectFatherController.selectedMotherNames.clear();
            selectFatherController.selectedMotherImages.clear();
            selectFatherController.search.value = true;

          },
          child: Container(
            height: 45,
            width: 70,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: appColors.selectedColor.value,
                    width: 2
                )
            ),
            child: Center(
              child: Text("Reset"),
            ),
          ),
        ),
        SizedBox(width: 16,)
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 12,),
            Obx(() {
              if(selectFatherController.selectedFatherNames.isEmpty){
                return SizedBox();
              }
              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectFatherController.selectedFatherNames.length,
                  itemBuilder: (context, index) {
                    bool isLast = index == selectFatherController.selectedFatherNames.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// ===== LEFT LINE + DOT =====
                        Column(
                          children: [
                            // Line covering husband + wife height
                            Container(
                              width: 4,
                              height: 60,
                              color: AppColors.text,
                            ),

                            // Dot between husband & wife
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.text,
                                shape: BoxShape.circle,
                              ),
                            ),

                            // Line till wife
                            Container(
                              width: 4,
                              height: 60,
                              color: AppColors.text,
                            ),

                            // Continue line for next couple
                            if (!isLast)
                              Container(
                                width: 4,
                                height: 10,
                                color: AppColors.text,
                              ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        /// ===== HUSBAND & WIFE CONTAINERS =====
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(
                                height: 0,
                                width: double.infinity,
                              ),
                              /// Husband
                              Container(
                                width : Get.width - 60,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.selectedColor.value,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 6),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    selectFatherController.selectedFatherImages[index].isNotEmpty
                                        ? CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: selectFatherController.selectedFatherImages[index]
                                              .startsWith('http')
                                              ? Image.network(
                                            selectFatherController.selectedFatherImages[index],
                                            fit: BoxFit.contain,
                                          )
                                              : Image.file(
                                            File(selectFatherController.selectedFatherImages[index]),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    )
                                        : CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      child: ClipOval(
                                        child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset("assets/images/no-image.png",fit: BoxFit.contain,)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectFatherController.selectedFatherNames[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyBold
                                          .copyWith(color: AppColors.white),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                      onTap: (){
                                        print("Father ID hello ${selectFatherController.ancestorList[index]["id"].toString()}");
                                        selectFatherController.getChildren(fatherId: selectFatherController.ancestorList[index]["id"].toString());
                                        Get.bottomSheet(Container(
                                          height: 400,
                                          width: Get.width,
                                          padding: const EdgeInsets.all(16),
                                          decoration: const BoxDecoration(
                                            color: Colors
                                                .white,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Spacer(),
                                                  Text("Family Member",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Get.back();
                                                    },
                                                    child: SvgPicture.string(AppSvgs.closeCircle,color: AppColors.red,)),
                                                ],
                                              ),
                                              Obx(() =>  Expanded(
                                                child: ListView.builder(
                                                  itemCount: selectFatherController.listOfChildren.length,
                                                  itemBuilder: (context, index) {
                                                    final children = selectFatherController.listOfChildren[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      child: Row(
                                                        spacing: 8,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor: AppColors.white,
                                                            child: ClipOval(
                                                              child: children["profile_img"] == null ||
                                                                  children["profile_img"] == ""
                                                                  ? Image.asset(
                                                                "assets/images/no-image.png",
                                                                fit: BoxFit.contain,
                                                                width: 20,
                                                                height: 20,
                                                              )
                                                                  : Image.network(
                                                                children["profile_img"],
                                                                fit: BoxFit.contain,
                                                                width: 40,
                                                                height: 40,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(children["name"]??""),
                                                        ],
                                                      ),
                                                    );
                                                  },),
                                              ),)
                                            ]
                                          ),
                                        ));
                                      },
                                      child: Icon(Icons.info_outline)),
                              ),
                              SizedBox(height: 3,),
                              /// Wife
                              selectFatherController.selectedMotherNames.isEmpty
                                  ? Container(
                                width : Get.width - 60,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.selectedColor.value,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow:  [
                                    BoxShadow(color: Colors.black12, blurRadius: 6),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add,color: AppColors.white,),
                                    SizedBox(width: 8),
                                    Text(
                                      "Add Wife",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyBold
                                          .copyWith(color: AppColors.white),
                                    ),

                                  ],
                                ),
                              )
                                  :Container(
                                width : Get.width - 60,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: appColors.selectedColor.value,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow:  [
                                    BoxShadow(color: Colors.black12, blurRadius: 6),
                                  ],
                                ),
                                child: Row(
                                  children:  [
                                    selectFatherController.selectedMotherImages[index].isNotEmpty
                                        ? CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: selectFatherController.selectedMotherImages[index]
                                              .startsWith('http')
                                              ? Image.network(
                                            selectFatherController.selectedMotherImages[index],
                                            fit: BoxFit.contain,
                                          )
                                              : Image.file(
                                            File(selectFatherController.selectedMotherImages[index]),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    )
                                        : CircleAvatar(
                                      backgroundColor: AppColors.white,
                                      child: ClipOval(
                                        child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset("assets/images/no-image.png",fit: BoxFit.contain,)),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      selectFatherController.selectedMotherNames[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyBold
                                          .copyWith(color: AppColors.white),
                                    ),
                                    Spacer(),
                                    // GestureDetector(
                                    //     onTap : (){
                                    //       selectFatherController.change.value = true;
                                    //       selectFatherController.fatherName.text = selectFatherController.selectedFatherNames[index];
                                    //       selectFatherController.fatherImage.value = selectFatherController.selectedFatherImages[index];
                                    //       selectFatherController.wifeName.text = selectFatherController.selectedMotherNames[index];
                                    //       selectFatherController.wifeImage.value = selectFatherController.selectedMotherImages[index];
                                    //       bottomSheet(index);
                                    //       // selectFatherController.wifeName.text = selectFatherController.selectedMotherNames[index];
                                    //       // selectFatherController.wifeImage.value = selectFatherController.selectedMotherImages[index];
                                    //       // bottomSheet();
                                    //     },
                                    //     child: Text("Change",style: Theme.of(context).textTheme.body2Regular.copyWith(color: Colors.white,),)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25,)
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },),
            /// do you remember next generation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(() {
                if(selectFatherController.selectedFatherNames.isEmpty || selectFatherController.search.value){
                  return  Visibility(
                    visible: selectFatherController.search.value,
                    child: TypeAheadField<Map<String,dynamic>>(
                    controller: selectFatherController.searchFather,

                    itemBuilder: (context, value) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage: value["profile_img"] != null &&
                              value["profile_img"].toString().isNotEmpty
                              ? NetworkImage(value["profile_img"])
                              : const AssetImage("assets/images/no-image.png")
                          as ImageProvider,
                        ),
                        title: Text("${value["name"] ?? "Unknown"} ${value["surname"] ?? "Unknown"}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyBold
                              .copyWith(color: AppColors.text),
                        ),
                      );
                    },
                      loadingBuilder: (context) => const Text('Loading...'),
                      errorBuilder: (context, error) => const Text('Error!'),
                      emptyBuilder: (context) =>  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: (){
                              selectFatherController.searchFather.clear();
                              Future.microtask(() {
                                if (!Get.isBottomSheetOpen!) {
                                  bottomSheet(0,forNew: true);
                                }
                              });

                            },
                            child: SizedBox(
                              width: Get.width,
                              child: Text('Not Available. Would you like to add ?',style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
                            )
                          ,),
                      ),
                    builder: (context, controller, focusNode){
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: "Search Father Name...",
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: AppColors.text, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: AppColors.text, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: AppColors.text, width: 1),
                          ),
                        ),
                      );
                    },
                    // onSelected: (value) async {
                    //   // prevent duplicate
                    //
                    //   await selectFatherController.loadFullFamilyTree(value["id"]);
                    //   if (!selectFatherController.selectedFatherNames.contains(value["name"])) {
                    //
                    //     selectFatherController.selectedFatherNames.add(value["name"]);
                    //     selectFatherController.selectedFatherImages.add(value["profile_img"]);
                    //     selectFatherController.lastIndexName.value =  value["name"].toString();
                    //
                    //     selectFatherController.selectedMotherNames.add(value["husband_wife_of"]["name"]);
                    //     selectFatherController.selectedMotherImages.add(value["husband_wife_of"]["profile_img"]);
                    //
                    //   }
                    //   selectFatherController.searchFather.clear();
                    //   selectFatherController.search.value = false;
                    //
                    //
                    //
                    // },
                      onSelected: (value) async {
                        FocusScope.of(context).unfocus();
                        selectFatherController.search.value = false;
                        selectFatherController.searchFather.clear();

                        selectFatherController.ancestorList.clear();

                        await selectFatherController.loadFullFamilyTree(value["id"]);
                        selectFatherController.fatherID.value = value["id"];
                        selectFatherController.motherID.value = value["husband_wife_of"]["id"];
                        print("value id  ${value["id"]}");
                      },
                    suggestionsCallback: (search) async {
                      if (search.trim().length < 3) {
                        return null;
                      }

                      await selectFatherController.getParent();
                      return selectFatherController.searchFatherList(search);
                    },

                  ),);
                  selectFatherController.search.value = false;
                }
                else if(selectFatherController.selectedFatherNames.isNotEmpty){
                  return Container(
                    width: Get.width,
                      decoration: BoxDecoration(
                        color: appColors.selectedColor.value,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff14453D33).withValues(alpha: 0.5),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Do You Remember ${selectFatherController.lastIndexName.value} Father",
                            style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),
                            ),
                            GestureDetector(
                              onTap: (){
                                selectFatherController.search.value = true;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.string(AppSvgs.add,color: AppColors.white),
                                  Text("ADD",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }
                else{
                  return SizedBox();
                }
              },),
            ),
            SizedBox(height: 50,),
            Obx(() => selectFatherController.selectedFatherNames.isNotEmpty
                ?Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: () {
                      if (selectFatherController.selectedFatherNames.isNotEmpty &&
                          selectFatherController.selectedFatherImages.isNotEmpty &&
                          selectFatherController.selectedMotherNames.isNotEmpty &&
                          selectFatherController.selectedMotherImages.isNotEmpty) {

                        selectFatherController.selectFatherName.value = true;

                        selectFatherController.nameFather.value =
                            selectFatherController.selectedFatherNames.first;
                        selectFatherController.imageFather.value =
                            selectFatherController.selectedFatherImages.first;

                        selectFatherController.nameMother.value =
                            selectFatherController.selectedMotherNames.first;
                        selectFatherController.imageMother.value =
                            selectFatherController.selectedMotherImages.first;

                        Get.back();
                      } else {
                        selectFatherController.selectFatherName.value = false;
                        Get.snackbar(
                          "Selection Required",
                          "Please select both father and mother",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: appColors.selectedColor.value,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text("Select",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),),
                    ),
                  ),
                )
                : SizedBox(),),

          ],
        ),
      ),
    );
  }

  void bottomSheet(int index,{bool forNew=false}) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),
                selectFatherController.selectedFatherNames.isEmpty
                    ? Text("Add Your Parent",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),)
                    : Text("Add ${selectFatherController.lastIndexName.value}'s Parent",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
                Spacer(),
                GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: SvgPicture.string(AppSvgs.closeCircle,color: AppColors.red,))
              ],
            ),
            const SizedBox(height: 12),
            Text("Father Info..",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),),
            const SizedBox(height: 12),
            Row(
              spacing: 16,
              children: [
                Obx(() =>  GestureDetector(
                  onTap: (){
                    selectFatherController.profileImagePicker();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectFatherController.fatherImage.isEmpty ? AppColors.text : AppColors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      image: selectFatherController.fatherImage.isNotEmpty
                          ? DecorationImage(
                        image: getImageProvider(
                          selectFatherController.fatherImage.value,
                        ),
                        fit: BoxFit.contain,
                      )
                          :  null,
                    ),
                    child: selectFatherController.fatherImage.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          AppSvgs.user,
                          color: AppColors.white,
                          height: 40,
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Upload Profile",
                            style: Theme.of(context)
                                .textTheme
                                .body1Bold
                                .copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                        : SizedBox(),
                  ),
                ),),
                Expanded(
                  child: Column(
                    spacing: 8,
                    children: [
                      AppTextFormField(labelText: "Father Name", controller: selectFatherController.fatherName),
                      AppTextFormField(labelText: "Mobile No.", controller: selectFatherController.fatherNumber,keyboardType: TextInputType.number,maxLength: 10,),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("Mother Info..",style: Theme.of(context).textTheme.body1SemiBold.copyWith(color: AppColors.text),),
            const SizedBox(height: 12),
            Row(
              spacing: 16,
              children: [
                Obx(() =>  GestureDetector(
                  onTap: (){
                    selectFatherController.wifeImagePicker();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: selectFatherController.wifeImage.isEmpty ? AppColors.text : AppColors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      image: selectFatherController.wifeImage.isNotEmpty
                          ? DecorationImage(
                        image: getImageProvider(
                          selectFatherController.wifeImage.value,
                        ),
                        fit: BoxFit.contain,
                      )
                          : null,
                        // image: selectFatherController.fatherImage.isNotEmpty
                        //     ? DecorationImage(image: selectFatherController.fatherImage.value.startsWith("http")
                        //     ? NetworkImage(selectFatherController.fatherImage.value)
                        //     : FileImage(File(selectFatherController.fatherImage.value))
                        // as ImageProvider,
                        //   fit: BoxFit.contain,
                        // ) :
                        // null
                    ),
                    child: selectFatherController.wifeImage.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          AppSvgs.user,
                          color: AppColors.white,
                          height: 40,
                          width: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Upload Profile",
                            style: Theme.of(context)
                                .textTheme
                                .body1Bold
                                .copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                        : SizedBox(),
                  ),
                ),),
                Expanded(child: Column(
                  spacing: 8,
                  children: [
                    AppTextFormField(labelText: "Wife Name", controller: selectFatherController.wifeName),
                    AppTextFormField(labelText: "Mobile No.", controller: selectFatherController.wifeNumber,maxLength: 10,keyboardType: TextInputType.number,),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 12),

            Center(
              child: GestureDetector(
                onTap: (){
                  // if(selectFatherController.change.value = true){

                  if(addMemberController.addApiCall.value == true){
                    selectFatherController.selectedFatherNames.add(selectFatherController.fatherName.text.toString());
                    selectFatherController.selectedFatherImages.add(selectFatherController.fatherImage.value);

                    selectFatherController.selectedMotherNames.add(selectFatherController.wifeName.text.toString());
                    selectFatherController.selectedMotherImages.add(selectFatherController.wifeImage.toString());

                    selectFatherController.fatherName.clear();
                    selectFatherController.fatherImage.value = "";
                    selectFatherController.search.value = false;
                    Get.back();
                  }
                  else{
                    print("jsdhfksdfhksdfhskdfh");
                    // addMemberController.addMember();
                  }

                  if(!forNew){

                    selectFatherController.selectedFatherNames[index] =
                        selectFatherController.fatherName.text.trim();

                    selectFatherController.selectedFatherImages[index] =
                        selectFatherController.fatherImage.value;

                    selectFatherController.selectedMotherNames[index] =
                        selectFatherController.wifeName.text.trim();

                    selectFatherController.selectedMotherImages[index] =
                        selectFatherController.wifeImage.value;

                    selectFatherController.change.value = false;
                    Get.back();


                  }
                  else{
                    selectFatherController.selectedFatherNames.add(selectFatherController.fatherName.text.toString());
                    selectFatherController.selectedFatherImages.add(selectFatherController.fatherImage.value);

                    selectFatherController.selectedMotherNames.add(selectFatherController.wifeName.text.toString());
                    selectFatherController.selectedMotherImages.add(selectFatherController.wifeImage.value);
                    print("show the wife image ${selectFatherController.selectedMotherImages}");

                    ///api call
                    print("djsfksdjhfksdjfhksdfksdfhsdf");
                    addMemberController.addParent();

                    selectFatherController.fatherName.clear();
                    selectFatherController.fatherImage.value = "";
                    selectFatherController.search.value = false;
                    Get.back();
                  }
                  selectFatherController.lastIndexName.value = selectFatherController.selectedFatherNames.last;
                  selectFatherController.fatherName.clear();
                  selectFatherController.wifeName.clear();
                  selectFatherController.fatherImage.value = "";
                  selectFatherController.wifeImage.value = "";
                  selectFatherController.search.value = false;

                },
                child: Container(
                  height: 45,
                  width: 180,
                  decoration: BoxDecoration(
                    color: appColors.selectedColor.value,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: selectFatherController.change.value == true ? Center(child: Text("Update",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),)
                      :Center(child: Text("Add",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ImageProvider getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

}
