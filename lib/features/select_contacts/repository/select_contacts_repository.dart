import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/user_model.dart';

final selectContactsRepository = Provider(
  (ref) => SelectContactsRepository(firestore: FirebaseFirestore.instance),
);

class SelectContactsRepository {
  final FirebaseFirestore firestore;

  SelectContactsRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact selectedContact) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userCollection =
          await firestore.collection("users").get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        UserModel userData = UserModel.fromMap(document.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(" ", '');

        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, mobileChatScreen, arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'profilePic': userData.profilePic,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: "Number does not exists on this app");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
