part of 'service_bloc.dart';

class ServiceState extends Equatable {
  const ServiceState({
    required this.initialList,
    this.isOn = false,
    this.isConnected = false,
    this.lastModifiedAttribute = '',
    this.service = '',
  });

  final List<CategoryModel> initialList;
  final bool isOn;
  final bool isConnected;
  final String lastModifiedAttribute;
  final String service;

  ServiceState copyWith({
    List<CategoryModel>? initialList,
    bool? isOn,
    bool? isConnected,
    String? lastModifiedAttribute,
    String? service,
  }) {
    return ServiceState(
      initialList: initialList ?? this.initialList,
      isOn: isOn ?? this.isOn,
      lastModifiedAttribute: lastModifiedAttribute ?? this.lastModifiedAttribute,
      isConnected: isConnected ?? this.isConnected,
      service: service ?? this.service,
    );
  }

  @override
  List<Object> get props => [initialList, isOn, lastModifiedAttribute, isConnected, service];
}
