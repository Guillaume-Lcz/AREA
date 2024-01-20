import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/widgets/input_data/action/get_time.dart';
import 'package:reactobot/widgets/input_data/reaction/discord_input.dart';
import 'package:reactobot/widgets/input_data/reaction/gmail_input.dart';

import '../../bloc/service/service_bloc.dart';

class CheckData {
  const CheckData(this.context);

  final BuildContext context;

  void checkData({
    required Map<String, dynamic> action,
    required int index,
    required String actionKey,
    required String service,
  }) async {
    for (var dataElement in action['data']) {
      var keysList = dataElement.keys.toList();
      for (var key in keysList) {
        switch (key) {
          case 'hour':
            if (action['name'] == 'every_month') {
              DateTime? selectedDate = await GetTime(context: context).selectDate();
              if (selectedDate != null) {
                if (!context.mounted) return;
                context.read<ServiceBloc>().add(
                      ActionsSubmitEvent(
                        data: selectedDate,
                        index: index,
                        actionKey: actionKey,
                        service: service,
                      ),
                    );
                Navigator.of(context).popUntil((Route route) => route.isFirst);
              }
            }
            if (action['name'] == 'every_day') {
              if (!context.mounted) return;
              DateTime? selectedDate = await GetTime(context: context).selectTime();
              if (selectedDate != null) {
                if (!context.mounted) return;
                context.read<ServiceBloc>().add(
                      ActionsSubmitEvent(
                        data: selectedDate,
                        index: index,
                        actionKey: actionKey,
                        service: service,
                      ),
                    );
                Navigator.of(context).popUntil((Route route) => route.isFirst);
              }
            }
            break;
          case 'channel_id':
            if (action['name'] == 'post_message') {
              showModalBottomSheet(
                elevation: 5,
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return DiscordInput(
                    index: index,
                    actionKey: actionKey,
                    service: service,
                  );
                },
              );
            }
            break;
          case 'to':
            if (action['name'] == 'post_message') {
              showModalBottomSheet(
                elevation: 5,
                showDragHandle: true,
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return GmailInput(
                    index: index,
                    actionKey: actionKey,
                    service: service,
                  );
                },
              );
            }
            break;
        }
      }
    }
  }
}
