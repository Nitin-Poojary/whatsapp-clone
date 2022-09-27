import 'package:flutter/material.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/error_widget.dart';
import 'package:whatsappclone/features/auth/screens/login_screen.dart';
import 'package:whatsappclone/features/auth/screens/otp_screen.dart';
import 'package:whatsappclone/features/auth/screens/user_info_screen.dart';
import 'package:whatsappclone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsappclone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsappclone/screens/mobile_screen_layout.dart';

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
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Some error occured"),
        ),
      );
  }
}
