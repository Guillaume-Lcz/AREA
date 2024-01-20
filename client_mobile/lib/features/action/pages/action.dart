import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/area/area_bloc.dart';
import 'package:reactobot/features/action/widgets/action_card.dart';
import 'package:reactobot/widgets/user_requests/user_requests.dart';

import '../../../bloc/actions/actions_bloc.dart';
import '../../../bloc/actions/actions_model.dart';
import '../../../bloc/data/data_bloc.dart';
import '../../../bloc/service/service_bloc.dart';
import '../widgets/add_action_reaction_to_server.dart';

class ConfigureActionPage extends StatefulWidget {
  const ConfigureActionPage({super.key});

  @override
  State<ConfigureActionPage> createState() => _ConfigureActionPageState();
}

class _ConfigureActionPageState extends State<ConfigureActionPage> {
  @override
  Widget build(BuildContext context) {
    void addNewCard(int index) {
      if (index != 0 && context.read<ActionsBloc>().state.actionCards.last.name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "You must complete the previous ${index == 1 ? 'action' : 'reaction'} before adding a new one."),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ActionModel newAction = ActionModel(
          id: '${context.read<ActionsBloc>().state.actionCards.length + 1}',
          name: '',
          service: '',
        );
        context.read<ActionsBloc>().add(AddActionEvent(newAction));
      }
    }

    Widget addCardButton(int index) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            addNewCard(index);
          },
          child: Text(
            index == 0 ? 'Add an Action' : 'Add a Reaction',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return BlocListener<DataBloc, DataState>(
      listener: (context, state) async {
        if (state.isLoading) {
          if (await AddActionReactionToServer().send(context, state)) {
            if (!context.mounted) return;
            context.read<ActionsBloc>().add(const ResetActionsEvent());
            context.read<ServiceBloc>().add(const ResetEvent());
            context.read<DataBloc>().add(const ProcessResetDataList());
            context.read<AreaBloc>().add(const ProcessResetAreaDataModel());
            UserRequests(context: context).getArea();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configure Actions'),
          actions: [
            IconButton(
              onPressed: () {
                var actions = context.read<ActionsBloc>().state.actionCards;
                if (actions.length > 1 && actions[1].name.isNotEmpty) {
                  AddActionReactionToServer().add(context, actions);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You must have at least one action and one reaction.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<ActionsBloc, ActionState>(
              builder: (BuildContext context, ActionState state) {
                if (state.actionCards.isNotEmpty) {
                  return Column(
                    children: <Widget>[
                      ...state.actionCards.asMap().entries.map((MapEntry<int, ActionModel> entry) =>
                          ConfigureActionCard(index: entry.key)),
                      const SizedBox(height: 16),
                      addCardButton(state.actionCards.length),
                    ],
                  );
                } else {
                  return addCardButton(0);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
