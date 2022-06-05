// import 'package:dalxiz/screens/user/user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Messages extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: FirebaseAuth.instance.currentUser,
//       builder: (ctx, futureSnapshot) {
//         if (futureSnapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('users')
//                 .snapshots(),
//             builder: (ctx, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               final chatDocs = snapshot.data.documents;
//               return ListView.builder(
//                 reverse: true,
//                 itemCount: chatDocs.length,
//                 itemBuilder: (ctx, index) => ProfileUI2(
//                   chatDocs[index]['name'],
//                   chatDocs[index]['email'],
//                   chatDocs[index]['phone'] == futureSnapshot.data.uid,
//                   key: ValueKey(chatDocs[index].documentID),
//                 ),
//               );
//             });
//       },
//     );
//   }
// }
