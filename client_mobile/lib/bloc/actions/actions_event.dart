part of 'actions_bloc.dart';

abstract class ActionsEvent extends Equatable {
  const ActionsEvent();

  @override
  List<Object> get props => [];
}

class AddActionEvent extends ActionsEvent {
  final ActionModel actionModel;

  const AddActionEvent(this.actionModel);

  @override
  List<Object> get props => [actionModel];
}

class RemoveActionEvent extends ActionsEvent {
  const RemoveActionEvent({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class UpdateActionEvent extends ActionsEvent {
  const UpdateActionEvent({
    required this.index,
    required this.newAction,
    required this.service,
  });
  final int index;
  final String newAction;
  final String service;

  @override
  List<Object> get props => [index, newAction];
}

class ResetActionsEvent extends ActionsEvent {
  const ResetActionsEvent();

  @override
  List<Object> get props => [];
}
