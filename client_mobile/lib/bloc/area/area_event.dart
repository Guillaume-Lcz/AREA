part of 'area_bloc.dart';

abstract class AreaEvent extends Equatable {
  const AreaEvent();

  @override
  List<Object> get props => [];
}

class ProcessReceivedAreaData extends AreaEvent {
  const ProcessReceivedAreaData({required this.data});

  final String data;

  @override
  List<Object> get props => [data];
}

class ProcessResetAreaDataModel extends AreaEvent {
  const ProcessResetAreaDataModel();

  @override
  List<Object> get props => [];
}
