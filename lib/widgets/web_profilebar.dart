// import 'package:flutter/material.dart';
// import 'package:whatsappclone/common/utils/colors.dart';

// class WebProfileBar extends StatelessWidget {
//   const WebProfileBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.077,
//       padding: const EdgeInsets.all(10),
//       decoration: const BoxDecoration(
//         color: webAppBarColor,
//         border: Border(
//           right: BorderSide(
//             width: 0,
//             color: greyColor,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(contacts[0]["profilePic"].toString()),
//           ),
//           const Spacer(),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.comment,
//               color: greyColor,
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.more_vert,
//               color: greyColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
