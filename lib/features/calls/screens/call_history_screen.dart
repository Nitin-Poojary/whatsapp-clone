import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/calls/controller/call_controller.dart';
import 'package:whatsappclone/models/call_model.dart';

import '../../../common/utils/colors.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder(
        stream: ref.read(callControllerProvider).getCallHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          List<CallModel> snapshotData = snapshot.data!;
          return ListView.separated(
            itemBuilder: (context, index) {
              return InkWell(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      snapshotData[index].receiverPic,
                    ),
                  ),
                  title: Text(
                    snapshotData[index].receiverName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        snapshotData[index].hasDialed
                            ? const Icon(
                                Icons.call_made,
                                color: Colors.green,
                                size: 20,
                              )
                            : const Icon(
                                Icons.call_received,
                                color: Colors.red,
                                size: 20,
                              ),
                        Text(
                          DateFormat.Hm()
                              .format(snapshotData[index].timeCalled),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    snapshotData[index].isVideoCall
                        ? Icons.videocam_rounded
                        : Icons.call,
                    size: 25,
                    color: Colors.green,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              height: 8,
              thickness: 0,
            ),
            itemCount: snapshotData.length,
          );
        },
      ),
    );
  }
}
