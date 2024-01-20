part of 'actions_bloc.dart';

class ActionState extends Equatable {
  const ActionState({
    required this.actionCards,
  });

  final List<ActionModel> actionCards;

  ActionState copyWith({
    List<ActionModel>? actionCards,
  }) {
    return ActionState(
      actionCards: actionCards ?? this.actionCards,
    );
  }

  @override
  List<Object> get props => [actionCards];
}
