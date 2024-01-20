part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class ProcessReceivedData extends DataEvent {
  const ProcessReceivedData({required this.data});

  final Map<String, dynamic> data;

  @override
  List<Object> get props => [data];
}

class ProcessAddDataModel extends DataEvent {
  const ProcessAddDataModel({
    required this.id,
    required this.service,
    required this.name,
    required this.action,
    required this.reaction,
  });

  final int id;
  final String service;
  final String name;
  final List<Map<String, dynamic>> action;
  final List<Map<String, dynamic>> reaction;

  @override
  List<Object> get props => [service, name, action, reaction];
}

class ProcessResetDataList extends DataEvent {
  const ProcessResetDataList();

  @override
  List<Object> get props => [];
}

class ResetUserData extends DataEvent {
  const ResetUserData();

  @override
  List<Object> get props => [];
}

class ProcessFillListFinished extends DataEvent {
  const ProcessFillListFinished({required this.isFinished});

  final bool? isFinished;

  @override
  List<Object> get props => [];
}

class ProcessIsDiconnect extends DataEvent {
  const ProcessIsDiconnect({required this.isDiconnect});

  final bool? isDiconnect;

  @override
  List<Object> get props => [];
}
