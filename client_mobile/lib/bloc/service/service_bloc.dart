import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/service/service_model.dart';

import '../../constantes.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceState(initialList: categories)) {
    on<SwitchActReaSubmitEvent>(_onSwitchActReaEvent);
    on<ToggleServiceConnexion>(_onToggleServiceConnection);
    on<SetAllServicesDisconnected>(_setAllServicesDisconnected);
    on<SwitchIsConnected>(_onSwitchConnected);
    on<ActionsSubmitEvent>(_onActionSubmitEvent);
    on<ReactionsSubmitEvent>(_onReactionSubmitEvent);
    on<ResetLastModifiedEvent>(_onResetLastModifiedEvent);
    on<ResetEvent>(_onResetEvent);
    on<DeleteACardEvent>(_onDeleteACardEvent);
    on<AddDataEvent>(_onAddDataEvent);
  }

  void _onSwitchActReaEvent(SwitchActReaSubmitEvent event, Emitter<ServiceState> emit) {
    emit(state.copyWith(
      isOn: !state.isOn,
    ));
  }

  void _onToggleServiceConnection(ToggleServiceConnexion event, Emitter<ServiceState> emit) {
    final newList = List<CategoryModel>.from(state.initialList);
    final serviceIndex = newList.indexWhere((category) => category.service == event.serviceName);

    if (serviceIndex != -1) {
      newList[serviceIndex].isConnected = true;
    }

    emit(state.copyWith(
      initialList: newList,
    ));
  }

  void _setAllServicesDisconnected(SetAllServicesDisconnected event, Emitter<ServiceState> emit) {
    final newList = List<CategoryModel>.from(state.initialList).map((category) => category.copyWith(isConnected: false)).toList();

    emit(state.copyWith(
      initialList: newList,
    ));
  }

  void _onSwitchConnected(SwitchIsConnected event, Emitter<ServiceState> emit) {
    final index = event.index;
    final newList = List<CategoryModel>.from(state.initialList);

    newList[index].isConnected = newList[index].isConnected ? true : true;
    emit(state.copyWith(
      isConnected: !state.isConnected,
      initialList: newList,
    ));
  }

  void _onActionSubmitEvent(ActionsSubmitEvent event, Emitter<ServiceState> emit) {
    final int index = event.index;
    final String actionKey = event.actionKey;

    final newList = List<CategoryModel>.from(state.initialList);
    final actions = List<Map<String, dynamic>>.from(newList[index].action);
    final actionIndex = actions.indexWhere((action) => action['name'] == actionKey);

    if (actionIndex != -1) {
      actions[actionIndex]['active'] = true;

      if (actions[actionIndex].containsKey('data')) {
        var data = actions[actionIndex]['data'];
        for (var dataElement in data) {
          if (dataElement.containsKey('minute')) {
            dataElement['minute'] = event.data?.minute ?? 0;
          }
          if (dataElement.containsKey('hour')) {
            dataElement['hour'] = event.data?.hour ?? 0;
          }
          if (dataElement.containsKey('day')) {
            dataElement['day'] = event.data?.day;
          }
        }
      }
    }
    newList[index].action = actions;
    emit(state.copyWith(
      initialList: newList,
      lastModifiedAttribute: event.actionKey,
      service: event.service,
    ));
  }

  void _onReactionSubmitEvent(ReactionsSubmitEvent event, Emitter<ServiceState> emit) {
    final int index = event.index;
    final String reactionKey = event.reactionKey;

    final newList = List<CategoryModel>.from(state.initialList);

    final reactions = List<Map<String, dynamic>>.from(newList[index].reaction);
    final reactionIndex = reactions.indexWhere((reaction) => reaction['name'] == reactionKey);

    if (reactionIndex != -1) {
      reactions[reactionIndex]['active'] = true;

      if (reactions[reactionIndex].containsKey('data')) {
        var data = reactions[reactionIndex]['data'];
        for (var dataElement in data) {
          if (dataElement.containsKey('channel_id')) {
            dataElement['channel_id'] = event.channelIdDiscord ?? '';
          }
          if (dataElement.containsKey('body')) {
            dataElement['body'] = event.body;
          }
          if (dataElement.containsKey('subject')) {
            dataElement['subject'] = event.subjectGmail;
          }
          if (dataElement.containsKey('to')) {
            dataElement['to'] = event.idGmail;
          }
        }
      }
    }

    newList[index].reaction = reactions;
    emit(state.copyWith(
      initialList: newList,
      lastModifiedAttribute: event.reactionKey,
      service: event.service,
    ));
  }

  void _onResetLastModifiedEvent(ResetLastModifiedEvent event, Emitter<ServiceState> emit) {
    emit(state.copyWith(lastModifiedAttribute: ''));
  }

  void _onResetEvent(ResetEvent event, Emitter<ServiceState> emit) {
    final newList = List<CategoryModel>.from(state.initialList);

    for (var category in newList) {
      for (var action in category.action) {
        action['active'] = false;
      }
      for (var reaction in category.reaction) {
        reaction['active'] = false;
      }
    }
    emit(state.copyWith(initialList: newList));
  }

  void _onDeleteACardEvent(DeleteACardEvent event, Emitter<ServiceState> emit) {
    final newList = List<CategoryModel>.from(state.initialList);

    final categoryIndex = newList.indexWhere((CategoryModel category) => category.service == event.service);

    if (categoryIndex != -1) {
      for (var action in newList[categoryIndex].action) {
        action['active'] = false;
      }

      for (var reaction in newList[categoryIndex].reaction) {
        reaction['active'] = false;
      }
    }

    emit(state.copyWith(
      initialList: newList,
    ));
  }

  void _onAddDataEvent(AddDataEvent event, Emitter<ServiceState> emit) {
    final newList = List<CategoryModel>.from(state.initialList);

    for (var category in newList) {
      for (var reaction in category.reaction) {
        if (reaction.containsKey('data')) {
          for (var dataElement in reaction['data']) {
            if (dataElement['name'] == event.data) {
              // Mettre à jour 'dataElement' ici en fonction de la valeur que vous souhaitez ajouter/modifier
            }
          }
        }
      }
    }

    emit(state.copyWith(initialList: newList));
  }
}
