// import 'package:flutter/material.dart';

// import 'constant.dart';
// import 'home_screen.dart';
// import 'user/user.dart';
// import 'package:dalxiz/enum.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({
//     Key? key,
//     required this.selectedMenu,
//   }) : super(key: key);
//   final MenuState selectedMenu;
//   @override
//   Widget build(BuildContext context) {
//     final Color inActiveIconColor = Color(0xFFB6B6B6);
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -15),
//             blurRadius: 20,
//             color: Color(0xFFDADADA).withOpacity(0.15),
//           ),
//         ],
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(40),
//           bottomRight: Radius.circular(40),
//         ),
//       ),
//       child: SafeArea(
//           top: false,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.home,
//                 ),
//                 onPressed: () {
//                   // Navigator.push(
//                   //     context, MaterialPageRoute(builder: (_) => ProfileUI2()));
//                   // setState(() {
//                   //   selectedItem = item;
//                   // });
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.notifications_on),
//                 // icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 // icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
//                 icon: Icon(Icons.settings),
//                 onPressed: () {},
//               ),
//               IconButton(
//                   // icon: SvgPicture.asset(
//                   //   "assets/icons/User Icon.svg",
//                   icon: Icon(Icons.person),

//                   // color: MenuState.profile == selectedMenu
//                   //     ? kPrimaryColor
//                   //     : inActiveIconColor,

//                   onPressed: () {
//                       Navigator.pushNamed(context, .user/ProfileUI2);
//                     // Navigator.push(context,
//                     //     MaterialPageRoute(builder: (_) => ProfileUI2()));
//                   }),
//             ],
//           )),
//     );
//   }
// }

// class MenuState {}
