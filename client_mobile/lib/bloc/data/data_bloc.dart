import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_model.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataState(userData: UserData())) {
    on<ProcessAddDataModel>(_onProcessAddDataModelEvent);
    on<ProcessReceivedData>(_onProcessReceivedDataEvent);
    on<ProcessResetDataList>(_onProcessResetDataListEvent);
    on<ProcessFillListFinished>(_onProcessFillListFinishedEvent);
    on<ProcessIsDiconnect>(_onProcessIsDisconnectEvent);
    on<ResetUserData>(_onResetUserDataEvent);
  }

  void _onProcessAddDataModelEvent(ProcessAddDataModel event, Emitter<DataState> emit) {
    List<Map<String, dynamic>> updatedActions = List<Map<String, dynamic>>.from(event.action);
    List<Map<String, dynamic>> updatedReactions = List<Map<String, dynamic>>.from(event.reaction);

    for (var i = 0; i < updatedActions.length; i++) {
      if (updatedActions[i]['name'] == event.name) {
        updatedActions[i] = Map<String, dynamic>.from(updatedActions[i])..['active'] = true;
      }
    }

    for (var i = 0; i < updatedReactions.length; i++) {
      if (updatedReactions[i]['name'] == event.name) {
        updatedReactions[i] = Map<String, dynamic>.from(updatedReactions[i])..['active'] = true;
      }
    }

    DataModel newDataModel = DataModel(
      id: event.id,
      service: event.service,
      name: event.name,
      action: updatedActions,
      reaction: updatedReactions,
    );

    List<DataModel> updatedDataModels = List<DataModel>.from(state.userData.dataModel ?? []);
    updatedDataModels.add(newDataModel);
    UserData updatedUserData = state.userData.copyWith(dataModel: updatedDataModels);
    emit(state.copyWith(userData: updatedUserData));
  }

  void _onProcessReceivedDataEvent(ProcessReceivedData event, Emitter<DataState> emit) {
    final data = event.data;

    UserData userData = UserData(
      id: data['_id'],
      email: data['email'],
      name: data['name'],
      isGoogleAuth: data['isGoogle'] as bool,
      isDiscordAuth: (data['services'] as List).any((service) => service['discord'] == true),
      isSpotifyAuth: (data['services'] as List).any((service) => service['spotify'] == true),
    );

    emit(state.copyWith(userData: userData));
  }

  void _onProcessResetDataListEvent(ProcessResetDataList event, Emitter<DataState> emit) {
    UserData updatedUserData = state.userData.copyWith(dataModel: []);

    emit(state.copyWith(userData: updatedUserData, isLoading: false));
  }

  void _onResetUserDataEvent(ResetUserData event, Emitter<DataState> emit) {
    emit(DataState(userData: UserData()));
  }

  void _onProcessFillListFinishedEvent(ProcessFillListFinished event, Emitter<DataState> emit) {
    emit(state.copyWith(isLoading: event.isFinished));
  }

  void _onProcessIsDisconnectEvent(ProcessIsDiconnect event, Emitter<DataState> emit) {
    emit(state.copyWith(isDisconnect: event.isDiconnect));
  }

  // void _onProcessReceivedAreaDataEvent(ProcessReceivedAreaData event, Emitter<DataState> emit) {
  //   final String jsonData = event.data;
  //   List<dynamic> decodedJsonList = json.decode(jsonData);
  //
  //   print('decodedJsonList: $decodedJsonList');
  //
  //   if (!decodedJsonList.every((element) => element is Map<String, dynamic>)) {
  //     throw const FormatException('Les données JSON ne sont pas dans le format attendu.');
  //   }
  //
  //   List<UserData> userDataList = decodedJsonList
  //       .map((jsonItem) => UserData.fromJson(jsonItem as Map<String, dynamic>))
  //       .toList();
  //
  //   emit(state.copyWith(userDataList: userDataList));
  // }
}
