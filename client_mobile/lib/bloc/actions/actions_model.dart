class ActionModel {
  const ActionModel({
    required this.id,
    required this.name,
    required this.service,
  });

  final String id;
  final String name;
  final String service;

  ActionModel copyWith({
    String? id,
    String? name,
    String? service,
  }) {
    return ActionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      service: service ?? this.service,
    );
  }

  List<Object> get props => [id, name, service];
}
