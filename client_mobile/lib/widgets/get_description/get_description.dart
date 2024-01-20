import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';

import '../../bloc/service/service_model.dart';

class GetDescription {
  String get(BuildContext context, String areaKey) {
    String description = '';

    final state = context.read<ServiceBloc>().state;

    final newList = List<CategoryModel>.from(state.initialList);

    for (var category in newList) {
      var combinedList = List<Map<String, dynamic>>.from(category.action)..addAll(category.reaction);

      final areaIndex = combinedList.indexWhere((element) => element['name'] == areaKey);

      if (areaIndex != -1) {
        description = combinedList[areaIndex]['description'] ?? '';
        break;
      }
    }
    return description;
  }
}
