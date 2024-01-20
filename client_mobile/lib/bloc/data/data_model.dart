class UserData {
  UserData({
    this.id,
    this.email,
    this.name,
    this.isGoogleAuth,
    this.isDiscordAuth,
    this.isSpotifyAuth,
    this.dataModel,
    this.action,
    this.reactions,
  });

  String? id;
  String? email;
  String? name;
  bool? isGoogleAuth;
  bool? isDiscordAuth;
  bool? isSpotifyAuth;
  List<DataModel>? dataModel;
  DataModel? action;
  List<DataModel>? reactions;

  UserData copyWith({
    String? id,
    String? email,
    String? name,
    bool? isGoogleAuth,
    bool? isDiscordAuth,
    bool? isSpotifyAuth,
    List<DataModel>? dataModel,
  }) {
    return UserData(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isGoogleAuth: isGoogleAuth ?? this.isGoogleAuth,
      isSpotifyAuth: isSpotifyAuth ?? this.isSpotifyAuth,
      isDiscordAuth: isDiscordAuth ?? this.isDiscordAuth,
      dataModel: dataModel ?? this.dataModel,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['userId'],
      action: json['action'] != null ? DataModel.fromJson(json['action']) : null,
      reactions: json['reaction'] != null
          ? List<DataModel>.from(json['reaction'].map((model) => DataModel.fromJson(model)))
          : null,
    );
  }

  // factory UserData.fromJson(Map<String, dynamic> json) {
  //   return UserData(
  //     id: json['userId'],
  //     action: json['action'] != null ? DataModel.fromJson(json['action']) : null,
  //     reactions: json['reaction'] != null
  //         ? List<DataModel>.from(json['reaction'].map((model) => DataModel.fromJson(model)))
  //         : null,
  //   );
  // }
}

class DataModel {
  DataModel({
    this.id,
    this.service,
    this.name,
    this.action,
    this.reaction,
    this.description,
    this.data,
  });

  int? id;
  String? service;
  String? name;
  String? description;
  Map<String, dynamic>? data;
  List<Map<String, dynamic>>? action;
  List<Map<String, dynamic>>? reaction;

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      description: json['description'],
      service: json['service'],
      name: json['name'],
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic>? getAction() {
    if (id == 1 && action != null && action!.isNotEmpty) {
      var activeAction = action!.firstWhere(
        (a) => a['active'] == true,
        orElse: () => {},
      );

      if (activeAction.isNotEmpty) {
        Map<String, dynamic> modifiedAction = {
          'service': service?.toLowerCase(),
          'name': activeAction['name'],
          'description': activeAction['description'],
        };

        if (activeAction.containsKey('data') && activeAction['data'] is List) {
          var dataList = activeAction['data'] as List;
          if (dataList.isNotEmpty) {
            modifiedAction['data'] = dataList.first;
          }
        }

        return modifiedAction;
      }
    }
    return null;
  }

  List<Map<String, dynamic>>? getReaction() {
    if (id != 1) {
      if (reaction != null) {
        return reaction!
            .where((r) => r['active'] == true && r.containsKey('name') && r['name'].isNotEmpty)
            .map((r) {
          Map<String, dynamic> newReaction = {'service': service?.toLowerCase()};

          r.forEach((key, value) {
            if (key != 'active') {
              if (key == 'data' && value is List && value.isNotEmpty) {
                newReaction[key] = value.first;
              } else {
                newReaction[key] = value;
              }
            }
          });
          return newReaction;
        }).toList();
      }
    }
    return null;
  }

  DataModel copyWith({
    String? service,
    String? name,
    List<Map<String, dynamic>>? action,
    List<Map<String, dynamic>>? reaction,
  }) {
    return DataModel(
      service: service ?? this.service,
      name: name ?? this.name,
      action: action ?? this.action,
      reaction: reaction ?? this.reaction,
    );
  }
}
