import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/features/calls/controller/call_controller.dart';
import 'package:whatsappclone/models/call_model.dart';

import '../../../common/utils/page_routes.dart';

class CallPickupScreen extends ConsumerWidget {
  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  final Widget scaffold;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.read(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          if (!call.hasDialed) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 40,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Ink(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, callScreen,
                                    arguments: {
                                      'channelId': call.callId,
                                      'call': call,
                                      'isGroupChat': false,
                                    });
                              },
                              icon: const Icon(
                                Icons.call,
                                color: whiteColor,
                                size: 30,
                              ),
                            ),
                          ),
                          Ink(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call_end,
                                color: whiteColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
