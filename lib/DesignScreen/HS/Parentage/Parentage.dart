import 'package:family_app/Helpers/app_colors.dart';
import 'package:family_app/TextTheme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Parentage extends StatefulWidget {
  const Parentage({super.key});

  @override
  State<Parentage> createState() => _ParentageState();
}

class _ParentageState extends State<Parentage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        title: Text("Parentage",style: Theme.of(context).textTheme.bodyBold.copyWith(color: AppColors.text),),
      ),
      body: Column(
        children: [],
      )
    );
  }
}

//Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 90,
//               width: 500,
//               child: ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: 1,
//                 itemBuilder: (context, index) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                   Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 26,
//                         backgroundImage: AssetImage("assets/images/person.jpg"),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "Grand Mother",
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 16),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Grand Father",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               },),
//             ),
//             SizedBox(
//               height: 100,
//               width: 500,
//               child: ListView.builder(
//                 itemCount: 1,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   Row(
//                   children: [
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Grand Mother",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Grand Father",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Grand Mother",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Grand Father",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//                   ],
//                 );
//               },),
//             ),
//             SizedBox(
//               height: 200,
//               width: 500,
//               child: ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: 1,
//                 itemBuilder: (context, index) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   Row(
//                   children: [
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Son",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Daughter",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Son",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 26,
//                           backgroundImage: AssetImage("assets/images/person.jpg"),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Daughter",
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//                   ],
//                 );
//               },),
//             ),
//
//           ],
//         ),
//       )