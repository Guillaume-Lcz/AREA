import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_model.dart';
import '../../../widgets/input_data/check_data.dart';

class DisplayActions extends StatelessWidget {
  const DisplayActions({
    super.key,
    required this.map,
    required this.index,
  });

  final List<CategoryModel> map;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: map[index].action.length,
        itemBuilder: (BuildContext context, int i) {
          final action = map[index].action[i];
          return Column(
            children: [
              OutlinedButton(
                onPressed: map[index].isConnected
                    ? () {
                        if (action.containsKey('data') &&
                            action['data'] is List &&
                            action['data'].any((element) =>
                                element is Map<dynamic, dynamic> && element.isNotEmpty)) {
                          CheckData(context).checkData(
                            action: action,
                            index: index,
                            actionKey: action['name'],
                            service: map[index].service,
                          );
                        } else {
                          context.read<ServiceBloc>().add(
                                ActionsSubmitEvent(
                                  index: index,
                                  actionKey: action['name'],
                                  service: map[index].service,
                                ),
                              );
                          Navigator.of(context).popUntil((Route route) => route.isFirst);
                        }
                      }
                    : null,
                child: Text(action['description']),
              ),
              if (i < map[index].action.length - 1) const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
