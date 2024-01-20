import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'area_model.dart';

part 'area_event.dart';
part 'area_state.dart';

class AreaBloc extends Bloc<AreaEvent, AreaState> {
  AreaBloc() : super(const AreaState(areaList: [])) {
    on<ProcessReceivedAreaData>(_onProcessReceivedAreaDataEvent);
    on<ProcessResetAreaDataModel>(_onResetAreaDataModelEvent);
  }

  void _onProcessReceivedAreaDataEvent(ProcessReceivedAreaData event, Emitter<AreaState> emit) {
    emit(state.copyWith(areaList: [], area: []));
    final String jsonData = event.data;
    if (jsonData.isEmpty) return;
    List<dynamic> decodedJsonList = json.decode(jsonData);

    if (!decodedJsonList.every((element) => element is Map<String, dynamic>)) {
      throw const FormatException('Les données JSON ne sont pas dans le format attendu.');
    }

    List<List<AreaModel>> updatedAreaList = List<List<AreaModel>>.from(state.areaList ?? []);
    List<AreaModel> areaModelList = [];
    String? lastActionId;

    for (var jsonItem in decodedJsonList) {
      AreaModel areaModel = AreaModel.fromJson(jsonItem as Map<String, dynamic>);

      if (lastActionId != null && areaModel.action.id != lastActionId) {
        updatedAreaList.add(areaModelList);
        areaModelList = [];
      }

      areaModelList.add(areaModel);
      lastActionId = areaModel.action.id;
    }

    if (areaModelList.isNotEmpty) {
      updatedAreaList.add(areaModelList);
    }

    emit(state.copyWith(areaList: updatedAreaList));
  }

  void _onResetAreaDataModelEvent(ProcessResetAreaDataModel event, Emitter<AreaState> emit) {
    emit(state.copyWith(areaList: [], area: []));
  }
}
