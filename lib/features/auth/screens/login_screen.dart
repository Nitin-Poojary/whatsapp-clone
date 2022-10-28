import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/common/widgets/custom_button.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _phoneController;
  Country? country;
  bool isSendingPhoneNumber = false;

  @override
  void initState() {
    _phoneController = TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (newCountry) {
        setState(() {
          country = newCountry;
        });
      },
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = _phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      setState(() {
        isSendingPhoneNumber = true;
      });
      ref
          .read(authContollerProvider)
          .signinWithPhoneNumber(context, '+${country!.phoneCode}$phoneNumber');
    } else if (phoneNumber.isEmpty) {
      showSnackBar(context: context, content: "Enter a number");
    } else {
      showSnackBar(context: context, content: "Pick a country");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Enter you phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text('WhatsApp needs to verify your phone number '),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            TextButton(
              onPressed: pickCountry,
              child: const Text("Pick Country"),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (country != null)
                  Text(
                    "+${country!.phoneCode}",
                  ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "phone number",
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: CustomButton(
                text: "NEXT",
                onPressed: isSendingPhoneNumber ? null : sendPhoneNumber,
              ),
            )
          ],
        ),
      ),
    );
  }
}
