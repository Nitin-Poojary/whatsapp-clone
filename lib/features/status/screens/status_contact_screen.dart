import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/status/controller/status_controller.dart';

import '../../../common/utils/colors.dart';
import '../../../models/status_model.dart';

class StatusContactScreen extends ConsumerStatefulWidget {
  const StatusContactScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatusContactScreenState();
}

class _StatusContactScreenState extends ConsumerState<StatusContactScreen>
    with AutomaticKeepAliveClientMixin<StatusContactScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<List<Status>>(
          stream: ref.read(statusControllerProvider).getStatus(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Status statusData = snapshot.data![index];
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, statusScreen,
                      arguments: statusData),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                      ),
                      title: Text(
                        statusData.userName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: dividerColor,
                height: 8,
                thickness: 0,
              ),
            );
          },
        ),
      ),
    );
  }
}
