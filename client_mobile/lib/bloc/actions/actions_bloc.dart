import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'actions_model.dart';

part 'actions_event.dart';
part 'actions_state.dart';

class ActionsBloc extends Bloc<ActionsEvent, ActionState> {
  ActionsBloc() : super(const ActionState(actionCards: [])) {
    on<AddActionEvent>(_onAddActionEvent);
    on<RemoveActionEvent>(_onRemoveActionEvent);
    on<UpdateActionEvent>(_onUpdateActionEvent);
    on<ResetActionsEvent>(_onResetActionEvent);
  }

  void _onAddActionEvent(event, emit) {
    final currentState = state;
    final updatedList = List<ActionModel>.from(currentState.actionCards)..add(event.actionModel);
    emit(state.copyWith(actionCards: updatedList));
  }

  void _onRemoveActionEvent(RemoveActionEvent event, Emitter<ActionState> emit) {
    final currentState = state;

    List<ActionModel> updatedList =
        currentState.actionCards.where((ActionModel action) => action.name != event.name).toList();

    updatedList = updatedList
        .asMap()
        .map((index, action) => MapEntry(index, action.copyWith(id: '${index + 1}')))
        .values
        .toList();

    emit(state.copyWith(actionCards: updatedList));
  }

  // void _onRemoveActionEvent(RemoveActionEvent event, Emitter<ActionState> emit) {
  //   final currentState = state;
  //   final updatedList =
  //       currentState.actionCards.where((ActionModel action) => action.name != event.name).toList();
  //   emit(state.copyWith(actionCards: updatedList));
  // }

  void _onUpdateActionEvent(event, emit) {
    final currentState = state;
    final updatedList = List<ActionModel>.from(currentState.actionCards);
    updatedList[event.index] =
        updatedList[event.index].copyWith(name: event.newAction, service: event.service);
    emit(state.copyWith(actionCards: updatedList));
  }

  void _onResetActionEvent(event, emit) {
    emit(const ActionState(actionCards: []));
  }
}
