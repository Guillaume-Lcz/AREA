import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/actions/actions_model.dart';
import 'package:reactobot/bloc/data/data_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';
import 'package:reactobot/bloc/service/service_model.dart';

import '../../../widgets/user_requests/user_requests.dart';

class AddActionReactionToServer {
  void add(BuildContext context, List<ActionModel> actionCards) {
    List<CategoryModel> categories = context.read<ServiceBloc>().state.initialList;
    DataBloc dataBloc = context.read<DataBloc>();

    actionCards.sort((a, b) => a.id.compareTo(b.id));

    for (var actionCard in actionCards) {
      List<Map<String, dynamic>> actions = [];
      List<Map<String, dynamic>> reactions = [];

      for (var category in categories) {
        if (category.service == actionCard.service) {
          actions.addAll(category.action);
          reactions.addAll(category.reaction);
        }
      }

      dataBloc.add(ProcessAddDataModel(
        id: int.parse(actionCard.id),
        service: actionCard.service,
        name: actionCard.name,
        action: actions,
        reaction: reactions,
      ));
    }
    dataBloc.add(const ProcessFillListFinished(isFinished: true));
  }

  Future<bool> send(BuildContext context, state) async {
    if (state.userData.dataModel != null && state.userData.dataModel!.isNotEmpty) {
      Map<String, dynamic>? firstAction;
      List<Map<String, dynamic>> allReactions = [];

      for (var dataModel in state.userData.dataModel!) {
        var action = dataModel.getAction();
        var reactions = dataModel.getReaction();

        if (firstAction == null && action != null) {
          firstAction = action;
        }
        if (reactions != null && reactions.isNotEmpty) {
          allReactions.addAll(reactions);
        }
      }

      Map<String, dynamic> finalJson = {
        "action": firstAction,
        "reaction": allReactions,
      };

      String jsonString = jsonEncode(finalJson);
      print(jsonString);

      if (await UserRequests(context: context).createNewArea(jsonString) == true) {
        return true;
      }
      if (!context.mounted) return false;
      context.read<DataBloc>().add(const ProcessResetDataList());
    }
    return false;
  }
}
