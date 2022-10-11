import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/config/agora_config.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/calls/controller/call_controller.dart';
import 'package:whatsappclone/models/call_model.dart';

import '../../../common/utils/colors.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://whatsappclonenp.herokuapp.com';

  @override
  void initState() {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );

    initAgora();
    super.initState();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                      onPressed: () async {
                        await client!.engine.leaveChannel();
                        ref.read(callControllerProvider).endCall(
                              context,
                              widget.call.callerId,
                              widget.call.receiverId,
                            );
                        Navigator.pop(context);
                      },
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
    );
  }
}
