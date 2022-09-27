import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/user_model.dart';
import 'package:whatsappclone/repository/common_firebase_storage_repository.dart';
import 'package:whatsappclone/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider(((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
}));

class AuthRepository {
  AuthRepository({required this.auth, required this.firestore});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<UserModel?> getCurrentUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (firebaseAuthException) {
            throw Exception(firebaseAuthException.message);
          },
          codeSent: (verificationId, resendToken) {
            Navigator.pushNamed(context, otpScreen, arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verityOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(phoneAuthCredential);
      Navigator.pushNamedAndRemoveUntil(
          context, userInfoScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFireStore(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = defaultPhotoURL;

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase("profilePic/$uid", profilePic);
      }

      UserModel user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);

      await firestore.collection("users").doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileScreenLayout(),
          ),
          (route) => false);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<UserModel> userData(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }
}
