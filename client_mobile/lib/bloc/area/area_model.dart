class AreaModel {
  AreaModel({
    required this.id,
    required this.userId,
    required this.action,
    required this.reactions,
    required this.v,
  });

  String id;
  String userId;
  Action action;
  List<Reaction> reactions;
  int v;

  AreaModel copyWith({
    String? id,
    String? userId,
    Action? action,
    List<Reaction>? reactions,
    int? v,
  }) {
    return AreaModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      reactions: reactions ?? this.reactions,
      v: v ?? this.v,
    );
  }

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['_id'],
      userId: json['userId'],
      action: Action.fromJson(json['action']),
      reactions: (json['reaction'] as List)
          .map((x) => Reaction.fromJson(x as Map<String, dynamic>))
          .toList(),
      v: json['__v'],
    );
  }
}

class Action {
  Action({
    required this.id,
    required this.service,
    required this.name,
    required this.description,
    required this.data,
    required this.dataLocalServer,
  });
  String id;
  String service;
  String name;
  String description;
  Map<String, dynamic> data;
  Map<String, dynamic> dataLocalServer;

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      id: json['_id'],
      service: json['service'],
      name: json['name'],
      description: json['description'],
      data: json['data'],
      dataLocalServer: json['dataLocalServer'],
    );
  }
}

class Reaction {
  Reaction({
    required this.id,
    required this.service,
    required this.name,
    required this.description,
    required this.data,
    required this.dataLocalServer,
  });

  String id;
  String service;
  String name;
  String description;
  Map<String, dynamic> data;
  Map<String, dynamic> dataLocalServer;

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      id: json['_id'],
      service: json['service'],
      name: json['name'],
      description: json['description'],
      data: json['data'],
      dataLocalServer: json['dataLocalServer'],
    );
  }
}
