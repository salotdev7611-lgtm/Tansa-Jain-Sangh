import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:family_app/DesignScreen/HS/Add%20Member/Add_Member_Controller.dart';
import 'package:family_app/DesignScreen/HS/ContactsDetails/Add_Contacts_Controller.dart';
import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Helpers/app_svgs.dart';
import '../../../Widgets/TextFormFields/app_text_form_field.dart';

class SelectParent extends StatefulWidget {
  const SelectParent({super.key, required this.surname});

  final String surname;

  @override
  State<SelectParent> createState() => _SelectParentState();
}

class _SelectParentState extends State<SelectParent> {

  final AddContactsController addContactsController = Get.put(AddContactsController());
  final AppColors appColors = Get.put(AppColors());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addContactsController.search.value = true;

    print("surname hjhjhkjh ${widget.surname}");
    // addContactsController.getFather(father: '', surname: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Select Parent",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),

      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          child: Column(
            children: [

              SizedBox(height: 12,),
            Obx(() {
                if(addContactsController.selectedFatherNames.isEmpty){
                  return SizedBox();
                }

                else if (addContactsController.get.value){
                  return CircularProgressIndicator();
                }
                return  ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addContactsController.selectedFatherNames.length,
                  itemBuilder: (context, index) {
                    // final memberId = addContactsController.ancestorList[index];
                    bool isLast = index == addContactsController.selectedFatherNames.length - 1;

                    return Column(
                      children: [
                        Row(
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
                                        addContactsController.selectedFatherImages[index].isNotEmpty
                                            ? CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage: addContactsController.selectedFatherImages[index].startsWith('http')
                                              ? NetworkImage(addContactsController.selectedFatherImages[index],)
                                              : FileImage(File(addContactsController.selectedFatherImages[index],),
                                          ),
                                        )
                                            : CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage:
                                          const AssetImage("assets/images/no-image.png"),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          addContactsController.selectedFatherNames[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyBold
                                              .copyWith(color: AppColors.white),
                                        ),
                                        Spacer(),

                                        GestureDetector(
                                            onTap : (){
                                              addContactsController.change.value = true;

                                              addContactsController.fatherName.text = addContactsController.selectedFatherNames[index];
                                              addContactsController.fatherImage.value = addContactsController.selectedFatherImages[index];
                                              addContactsController.fatherMobileNo.text = addContactsController.selectedFatherNumber[index];
                                              addContactsController.dob.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(addContactsController.fatherDob[index]));
                                              addContactsController.deathDate.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(addContactsController.fatherDeathDate[index]));

                                              addContactsController.motherName.text = addContactsController.selectedMotherNames[index];
                                              addContactsController.motherImage.value = addContactsController.selectedMotherImages[index];
                                              addContactsController.motherMobileNo.text = addContactsController.selectedMotherNumber[index];
                                              addContactsController.dobMother.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(addContactsController.motherDob[index]));
                                              addContactsController.deathDateMother.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(addContactsController.motherDeathDate[index]));
                                              bottomSheet(index);
                                            },
                                            child: Text("Change",style: Theme.of(context).textTheme.body2Regular.copyWith(color: Colors.white,),)),
                                      ],
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: (){
                                          // addContactsController.id.value = memberId["id"].toString();
                                          print("addContactsController.id.value ${addContactsController.id.value}");
                                          addContactsController.getMember(fatherId: addContactsController.id.value);
                                          Get.bottomSheet(Container(
                                            height: 400,
                                            width: Get.width,
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
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
                                                  Obx(() {

                                                    if(addContactsController.listOfFamilyMember.isEmpty){
                                                      return Center(child: Text("No Data Found"));
                                                    }

                                                    return  Expanded(
                                                      child: ListView.builder(
                                                        itemCount: addContactsController.listOfFamilyMember.length,
                                                        itemBuilder: (context, index) {
                                                          final member = addContactsController.listOfFamilyMember[index];
                                                          return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                                            child: Row(
                                                              spacing: 8,
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage: NetworkImage(member["profile_img"]),
                                                                  backgroundColor: AppColors.white,
                                                                ),
                                                                Text("${member["name"].toString()}"),
                                                              ],
                                                            ),
                                                          );
                                                        },),
                                                    );
                                                  })
                                                ]
                                            ),
                                          ));
                                        },
                                        child: Icon(Icons.info_outline)),
                                  ),

                                  SizedBox(height: 10,),
                                  /// Wife
                                  addContactsController.selectedMotherNames.isEmpty
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
                                        addContactsController.selectedMotherImages[index].isNotEmpty
                                            ? CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage: addContactsController.selectedMotherImages[index].startsWith('http')
                                              ? NetworkImage(addContactsController.selectedMotherImages[index],)
                                              : FileImage(File(addContactsController.selectedMotherImages[index],),
                                          ),
                                        )
                                            : CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage:
                                          const AssetImage("assets/images/no-image.png"),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          addContactsController.selectedMotherNames[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyBold
                                              .copyWith(color: AppColors.white),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                            onTap : (){
                                              addContactsController.change.value = true;
                                              addContactsController.fatherName.text = addContactsController.selectedFatherNames[index];
                                              addContactsController.fatherImage.value = addContactsController.selectedFatherImages[index];
                                              addContactsController.fatherMobileNo.text = addContactsController.selectedFatherNumber[index];
                                              addContactsController.dob.text = addContactsController.fatherDob[index];
                                              addContactsController.deathDate.text = addContactsController.fatherDeathDate[index];


                                              addContactsController.motherName.text = addContactsController.selectedMotherNames[index];
                                              addContactsController.motherImage.value = addContactsController.selectedMotherImages[index];
                                              addContactsController.motherMobileNo.text = addContactsController.selectedMotherNumber[index];
                                              addContactsController.dobMother.text = addContactsController.motherDob[index];
                                              addContactsController.deathDateMother.text = addContactsController.motherDeathDate[index];

                                              bottomSheet(index);
                                              // addContactsController.motherName.text = addContactsController.selectedMotherNames[index];
                                              // addContactsController.motherImage.value = addContactsController.selectedMotherImages[index];
                                              // bottomSheet();
                                            },
                                            child: Text("Change",style: Theme.of(context).textTheme.body2Regular.copyWith(color: Colors.white,),)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );

              },),
              /// do you remember next generation
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Obx(() {
                  if(addContactsController.selectedFatherNames.isEmpty || addContactsController.search.value){
                    return  Visibility(
                      visible: addContactsController.search.value,
                      child:
                      TypeAheadField<Map<String,dynamic>>(
                        controller: addContactsController.searchFather,

                        decorationBuilder: (context, child) {
                          return Material(
                            color: AppColors.white,
                            elevation: 0,
                            borderRadius: BorderRadius.circular(5),
                            child: child,
                          );
                        },
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
                              addContactsController.searchFather.clear();
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
                        onSelected: (value) async {
                          FocusScope.of(context).unfocus();
                          addContactsController.search.value = false;
                          addContactsController.searchFather.clear();

                          addContactsController.ancestorList.clear();

                          await addContactsController.loadFullFamilyTree(value["id"]);
                        },

                        suggestionsCallback: (pattern) async {
                          if (pattern.trim().length < 3) {
                            return [];
                          }
                          await addContactsController.getFather(father: pattern, surname: widget.surname);
                          return addContactsController.getFilterList(pattern);
                        },
                      ),
                    );
                  }
                  else{
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
                              Text("Do You Remember ${addContactsController.lastIndexName.value} Father",
                                style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 22,
                                children: [
                                  Text("No",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.red),),
                                  GestureDetector(
                                      onTap: (){
                                        addContactsController.search.value = true;
                                        addContactsController.fatherName.clear();
                                        addContactsController.motherName.clear();
                                        addContactsController.fatherMobileNo.clear();
                                        addContactsController.motherMobileNo.clear();
                                        addContactsController.fatherImage.value = "";
                                        addContactsController.motherImage.value = "";
                                      },
                                      child: Text("Yes",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.lightGreen),)),
                                ],
                              )
                            ],
                          ),
                        ));
                  }
                },),
              ),

              SizedBox(height: 50,),
             Obx(() =>
             addContactsController.selectedFatherNames.isNotEmpty
                 ? GestureDetector(
               onTap: () {
                 print("STEP 1: Submit tapped");

                 print("FatherNames : ${addContactsController.selectedFatherNames}");
                 print("FatherImages: ${addContactsController.selectedFatherImages}");
                 print("FatherNumbers: ${addContactsController.selectedFatherNumber}");
                 print("MotherNames : ${addContactsController.selectedMotherNames}");
                 print("MotherImages: ${addContactsController.selectedMotherImages}");

                 if (addContactsController.selectedFatherNames.isEmpty) {
                   print("ERROR: Father name missing");
                   Get.snackbar("Error", "Father name missing");
                   return;
                 }

                 if (addContactsController.selectedMotherNames.isEmpty) {
                   print("ERROR: Mother name missing");
                   Get.snackbar("Error", "Mother name missing");
                   return;
                 }

                 addContactsController.selectFatherName.value = true;

                 // STEP 8: SAFE assignments
                 addContactsController.nameFather.value =
                     addContactsController.selectedFatherNames.first;

                 addContactsController.imageFather.value =
                     addContactsController.selectedFatherImages.first;

                 addContactsController.mobileNoFather.value =
                     addContactsController.selectedFatherNumber.first;

                 addContactsController.nameMother.value =
                     addContactsController.selectedMotherNames.first;

                 addContactsController.imageMother.value =
                     addContactsController.selectedMotherImages.first;

                 addContactsController.mobileNoMother.value = addContactsController.selectedMotherNumber.first;

                 print("STEP 9: Values assigned successfully");

                 Get.back();
                 FocusScope.of(context).nextFocus();
                 },
               child: Container(
                 height: 45,
                 decoration: BoxDecoration(
                   color: appColors.selectedColor.value,
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Center(child: Text("Submit",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.white),),),
               ),
             )
                 : SizedBox(),)
            ],
          ),
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
                addContactsController.selectedFatherNames.isEmpty
                    ? Text("Add Your Parent",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),)
                    : Text("Add ${addContactsController.lastIndexName.value}'s Parent",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.text),),
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
                    addContactsController.fatherImagePicker();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: addContactsController.fatherImage.isEmpty ? AppColors.text : AppColors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      image: addContactsController.fatherImage.isNotEmpty
                          ? DecorationImage(
                        image: getImageProvider(
                          addContactsController.fatherImage.value,
                        ),
                        fit: BoxFit.contain,
                      )
                          :  null,
                    ),
                    child: addContactsController.fatherImage.isEmpty
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
                      AppTextFormField(labelText: "Father Name", controller: addContactsController.fatherName),
                      AppTextFormField(labelText: "Mobile No.", controller: addContactsController.fatherMobileNo,keyboardType: TextInputType.number,maxLength: 10,),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: AppTextFormField(labelText: "Date Of Birth", controller: addContactsController.dob,maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }

                                // dd-mm-yyyy format
                                final RegExp dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                                if (!dateRegex.hasMatch(value.trim())) {
                                  return "(DD-MM-YYYY)";
                                }

                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: AppTextFormField(labelText: "Death Date", controller: addContactsController.deathDate,maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }

                                // dd-mm-yyyy format
                                final RegExp dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                                if (!dateRegex.hasMatch(value.trim())) {
                                  return "(DD-MM-YYYY)";
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      )
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
                    addContactsController.motherImagePicker();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: addContactsController.motherImage.isEmpty ? AppColors.text : AppColors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      image: addContactsController.motherImage.isNotEmpty
                          ? DecorationImage(
                        image: getImageProvider(
                          addContactsController.motherImage.value,
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
                    child: addContactsController.fatherImage.isEmpty
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
                    AppTextFormField(labelText: "Wife Name", controller: addContactsController.motherName),
                    AppTextFormField(labelText: "Mobile No.", controller: addContactsController.motherMobileNo,maxLength: 10,keyboardType: TextInputType.number,),
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(child: AppTextFormField(labelText: "Date Of Birth", controller: addContactsController.dobMother,maxLength: 10,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }

                            // dd-mm-yyyy format
                            final RegExp dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                            if (!dateRegex.hasMatch(value.trim())) {
                              return "(DD-MM-YYYY)";
                            }

                            return null;
                          },
                        )),
                        Expanded(child: AppTextFormField(labelText: "Death Date", controller: addContactsController.deathDateMother,maxLength: 10,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }

                            // dd-mm-yyyy format
                            final RegExp dateRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\d{4}$');

                            if (!dateRegex.hasMatch(value.trim())) {
                              return "(DD-MM-YYYY)";
                            }

                            return null;
                          },
                        )),
                      ],
                    )
                  ],
                )),
              ],
            ),
            const SizedBox(height: 12),

            Center(
              child: GestureDetector(
                onTap: (){
                  addContactsController.buildGrandParents();
                  // if(selectFatherController.change.value = true){
                  if(!forNew){
                    print("this no new for this");
                    addContactsController.selectedFatherNames[index] =
                        addContactsController.fatherName.text.trim();

                    addContactsController.selectedFatherImages[index] =
                        addContactsController.fatherImage.value;

                    addContactsController.selectedMotherNames[index] =
                        addContactsController.motherName.text.trim();

                    addContactsController.selectedMotherImages[index] =
                        addContactsController.motherImage.value;

                    addContactsController.change.value = false;
                    Get.back();
                    addContactsController.search.value = false;
                  }
                  else {
                    print("this is new for this");
                    /// ===== ADD PARENT =====
                    addContactsController.selectedFatherNames
                        .add(addContactsController.fatherName.text.trim());

                    addContactsController.selectedFatherImages
                        .add(addContactsController.fatherImage.value);

                    addContactsController.selectedFatherNumber
                        .add(addContactsController.fatherMobileNo.text.trim());

                    addContactsController.fatherDob.add(addContactsController.dob.text.trim());
                    addContactsController.fatherDeathDate.add(addContactsController.deathDate.text.trim());


                    addContactsController.selectedMotherNames
                        .add(addContactsController.motherName.text.trim());

                    addContactsController.selectedMotherImages
                        .add(addContactsController.motherImage.value);

                    addContactsController.selectedMotherNumber
                        .add(addContactsController.motherMobileNo.text.trim());

                    addContactsController.motherDob.add(addContactsController.dobMother.text.trim());
                    addContactsController.motherDeathDate.add(addContactsController.deathDateMother.text.trim());

                    /// ===== CLEAR =====
                    addContactsController.fatherName.clear();
                    addContactsController.motherName.clear();
                    addContactsController.dob.clear();
                    addContactsController.deathDate.clear();
                    addContactsController.dobMother.clear();
                    addContactsController.deathDateMother.clear();
                    addContactsController.fatherMobileNo.clear();
                    addContactsController.motherMobileNo.clear();
                    addContactsController.fatherImage.value = "";
                    addContactsController.motherImage.value = "";
                    print("object object ${addContactsController.selectedFatherNames}");

                    addContactsController.search.value = false;
                    Get.back();

                  }
                },
                child: Container(
                  height: 45,
                  width: 180,
                  decoration: BoxDecoration(
                    color: appColors.selectedColor.value,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: addContactsController.change.value == true ? Center(child: Text("Update",style: Theme.of(context).textTheme.body1Bold.copyWith(color: AppColors.white),),)
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

  Widget buildPersonCard({
    String? name,
    String? image,
    required Color color,
  }) {
    return Container(
      width: Get.width - 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: image != null && image.isNotEmpty
                ? NetworkImage(image)
                : const AssetImage("assets/images/no-image.png")
            as ImageProvider,
          ),
          const SizedBox(width: 8),
          Text(
            name ?? "Unknown",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

}
