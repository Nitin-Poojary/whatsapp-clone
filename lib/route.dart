import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/error_widget.dart';
import 'package:whatsappclone/features/auth/screens/login_screen.dart';
import 'package:whatsappclone/features/auth/screens/otp_screen.dart';
import 'package:whatsappclone/features/auth/screens/user_info_screen.dart';
import 'package:whatsappclone/features/group/screens/create_group_screen.dart';
import 'package:whatsappclone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsappclone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsappclone/features/status/screens/confirm_status_sceen.dart';
import 'package:whatsappclone/features/status/screens/status_contact_screen.dart';
import 'package:whatsappclone/screens/mobile_screen_layout.dart';

import 'features/status/screens/status_screen.dart';
import 'models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginScreen:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case homeScreen:
      return MaterialPageRoute(
        builder: (context) => const MobileScreenLayout(),
      );
    case otpScreen:
      final String verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case userInfoScreen:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case selectContactsScreen:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case mobileChatScreen:
      final Map<String, dynamic> arguments =
          settings.arguments as Map<String, dynamic>;
      final String name = arguments['name'];
      final String uid = arguments['uid'];
      final String profilePic = arguments['profilePic'];
      final bool isGroupChat = arguments['isGroupChat'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          profilePic: profilePic,
          isGroupChat: isGroupChat,
        ),
      );
    case statusContactScreen:
      return MaterialPageRoute(
        builder: (context) => const StatusContactScreen(),
      );
    case confirmStatusScreen:
      final File arguments = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: arguments),
      );
    case statusScreen:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusScreen(status: status),
      );
    case createGroupScreen:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Some error occured"),
        ),
      );
  }
}
