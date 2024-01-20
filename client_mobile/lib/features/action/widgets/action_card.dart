import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/actions/actions_bloc.dart';
import 'package:reactobot/bloc/actions/actions_model.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';

import '../../../widgets/error_message/error_message.dart';
import '../../../widgets/get_description/get_description.dart';
import '../../services/pages/services.dart';

class ConfigureActionCard extends StatefulWidget {
  const ConfigureActionCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<ConfigureActionCard> createState() => _ConfigureActionCardState();
}

class _ConfigureActionCardState extends State<ConfigureActionCard> {
  @override
  Widget build(BuildContext context) {
    String action = context.watch<ActionsBloc>().state.actionCards[widget.index].name;
    if (action.isEmpty) {
      final ServiceState lastModifiedAction = context.watch<ServiceBloc>().state;
      context.watch<ActionsBloc>().add(
            UpdateActionEvent(
              index: widget.index,
              newAction: lastModifiedAction.lastModifiedAttribute,
              service: lastModifiedAction.service,
            ),
          );
      context.watch<ServiceBloc>().add(const ResetLastModifiedEvent());
    }

    return Dismissible(
      key: Key(action),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final List<ActionModel> canDelete = context.read<ActionsBloc>().state.actionCards;
        if (widget.index == 0 &&
            canDelete.last.name.isNotEmpty &&
            canDelete.length > widget.index + 1) {
          ErrorMessage().snackBar(context: context, errorCode: 0);
          return false;
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Are you sure you want to delete this item?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        }
        return null;
      },
      onDismissed: (DismissDirection direction) {
        final actionCards = context.read<ActionsBloc>().state.actionCards;

        if (widget.index < actionCards.length) {
          final cardToDelete = actionCards[widget.index];

          final String name = cardToDelete.name;
          final String service = cardToDelete.service;

          context.read<ActionsBloc>().add(RemoveActionEvent(name: name));
          context.read<ServiceBloc>().add(DeleteACardEvent(name: name, service: service));
        }
      },
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  right: 4,
                  left: 16,
                  bottom: 8,
                ),
                child: action.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.index == 0 ? 'If' : 'Then',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            GetDescription().get(context, action),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.index == 0 ? 'If' : 'Then',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final ServiceBloc ison = context.read<ServiceBloc>();
                              final List<ActionModel> actionModelList =
                                  context.read<ActionsBloc>().state.actionCards;
                              if (widget.index != 0 &&
                                      actionModelList.last.name.isEmpty &&
                                      !ison.state.isOn ||
                                  widget.index == 0 && ison.state.isOn) {
                                //if (widget.index == 1 || widget.index == 0 && ison.state.isOn) {
                                ison.add(const SwitchActReaSubmitEvent());
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const Services(),
                                ),
                              );
                            },
                            icon: const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
