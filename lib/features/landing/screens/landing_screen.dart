import 'package:flutter/material.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
              width: double.infinity,
            ),
            Text(
              "Welcome to WhatsApp",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: size.height / 12,
            ),
            Image.asset(
              "assets/landing_bg.png",
              height: 340,
              width: 340,
              color: tabColor,
            ),
            SizedBox(
              height: size.height / 12,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(
                  color: greyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: size.width * 0.8,
              child: CustomButton(
                onPressed: () => navigateToLoginScreen(context),
                text: "AGREE AND CONTINUE",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
