part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class SwitchActReaSubmitEvent extends ServiceEvent {
  const SwitchActReaSubmitEvent();

  @override
  List<Object> get props => [];
}

class ToggleServiceConnexion extends ServiceEvent {
  const ToggleServiceConnexion({required this.serviceName});

  final String serviceName;

  @override
  List<Object> get props => [serviceName];
}

class SetAllServicesDisconnected extends ServiceEvent {
  const SetAllServicesDisconnected();

  @override
  List<Object> get props => [];
}

class SwitchIsConnected extends ServiceEvent {
  const SwitchIsConnected({
    required this.index,
  });

  final int index;

  @override
  List<Object> get props => [index];
}

class ActionsSubmitEvent extends ServiceEvent {
  const ActionsSubmitEvent({
    required this.index,
    required this.actionKey,
    required this.service,
    this.data,
  });

  final int index;
  final String actionKey;
  final String service;
  final DateTime? data;

  @override
  List<Object?> get props => [index, actionKey, service, data];
}

class ReactionsSubmitEvent extends ServiceEvent {
  const ReactionsSubmitEvent({
    required this.index,
    required this.reactionKey,
    required this.service,
    this.channelIdDiscord,
    this.body,
    this.idGmail,
    this.subjectGmail,
  });

  final int index;
  final String reactionKey;
  final String service;
  final String? channelIdDiscord;
  final String? body;
  final String? idGmail;
  final String? subjectGmail;

  @override
  List<Object?> get props => [
        index,
        reactionKey,
        service,
        channelIdDiscord,
        body,
        idGmail,
        subjectGmail,
      ];
}

class ResetLastModifiedEvent extends ServiceEvent {
  const ResetLastModifiedEvent();

  @override
  List<Object> get props => [];
}

class ResetEvent extends ServiceEvent {
  const ResetEvent();

  @override
  List<Object> get props => [];
}

class DeleteACardEvent extends ServiceEvent {
  const DeleteACardEvent({
    required this.name,
    required this.service,
  });

  final String name;
  final String service;
  @override
  List<Object> get props => [name, service];
}

class AddDataEvent extends ServiceEvent {
  const AddDataEvent({
    required this.data,
  });

  final String data;

  @override
  List<Object> get props => [data];
}
