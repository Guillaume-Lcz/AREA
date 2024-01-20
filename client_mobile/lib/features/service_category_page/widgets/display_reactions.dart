import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_model.dart';
import '../../../widgets/input_data/check_data.dart';

class DisplayReaction extends StatelessWidget {
  const DisplayReaction({
    super.key,
    required this.map,
    required this.index,
  });

  final List<CategoryModel> map;
  final int index;

  @override
  Widget build(BuildContext context) {
    final filteredReactions = map[index].reaction.where((reaction) => !reaction['active']).toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredReactions.length,
        itemBuilder: (BuildContext context, int i) {
          final reaction = filteredReactions[i];
          return Column(
            children: [
              OutlinedButton(
                onPressed: map[index].isConnected
                    ? () {
                        if (reaction.containsKey('data') &&
                            reaction['data'] is List &&
                            reaction['data'].any((element) =>
                                element is Map<dynamic, dynamic> && element.isNotEmpty)) {
                          CheckData(context).checkData(
                            action: reaction,
                            index: index,
                            actionKey: reaction['name'],
                            service: map[index].service,
                          );
                        } else {
                          context.read<ServiceBloc>().add(
                                ReactionsSubmitEvent(
                                  index: index,
                                  reactionKey: reaction['name'],
                                  service: map[index].service,
                                ),
                              );
                          Navigator.of(context).popUntil((Route route) => route.isFirst);
                        }
                      }
                    : null,
                child: Text(reaction['description']),
              ),
              if (i < filteredReactions.length - 1) const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
