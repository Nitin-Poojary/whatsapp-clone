import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({super.key, required this.verificationId});

  final String verificationId;

  void verifyOTP(BuildContext context, WidgetRef ref, String userOTP) {
    ref.read(authContollerProvider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifying your number"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
            width: double.infinity,
          ),
          const Text("We have sent an SMS with a code"),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(fontSize: 30),
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  verifyOTP(context, ref, value.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
