// import 'package:flutter/material.dart';
// import 'package:whatsappclone/common/utils/colors.dart';

// class WebChatAppbarr extends StatelessWidget {
//   const WebChatAppbarr({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.077,
//       padding: const EdgeInsets.all(10),
//       color: webAppBarColor,
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(contacts[0]["profilePic"].toString()),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Text(contacts[0]["name"].toString()),
//           const Spacer(),
//           const Icon(
//             Icons.search,
//             color: greyColor,
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             child: Icon(
//               Icons.more_vert,
//               color: greyColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
