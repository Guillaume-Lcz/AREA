import 'package:flutter/material.dart';

class CategoryModel {
  CategoryModel({
    required this.service,
    this.icon,
    this.activate = false,
    this.color = Colors.transparent,
    required this.action,
    required this.reaction,
    this.imageBlack = '',
    this.imageWhite = '',
    this.imageBlackSize = 15.0,
    this.imageWhiteSize = 15.0,
    required this.isConnected,
  });

  String service;
  IconData? icon;
  bool activate;
  Color? color;
  List<Map<String, dynamic>> action;
  List<Map<String, dynamic>> reaction;
  String? imageBlack;
  String? imageWhite;
  double? imageBlackSize;
  double? imageWhiteSize;
  bool isConnected;

  CategoryModel copyWith({
    String? service,
    IconData? icon,
    bool? activate,
    Color? color,
    List<Map<String, dynamic>>? action,
    List<Map<String, dynamic>>? reaction,
    String? imageBlack,
    String? imageWhite,
    double? imageBlackSize,
    double? imageWhiteSize,
    bool? isConnected,
  }) {
    return CategoryModel(
      service: service ?? this.service,
      icon: icon ?? this.icon,
      activate: activate ?? this.activate,
      color: color ?? this.color,
      action: action ?? this.action,
      reaction: reaction ?? this.reaction,
      imageBlack: imageBlack ?? this.imageBlack,
      imageWhite: imageWhite ?? this.imageWhite,
      imageBlackSize: imageBlackSize ?? this.imageBlackSize,
      imageWhiteSize: imageWhiteSize ?? this.imageWhiteSize,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  factory CategoryModel.fromJson(CategoryModel json) {
    return CategoryModel(
      service: json.service,
      activate: json.activate,
      action: List<Map<String, dynamic>>.from(json.action),
      reaction: List<Map<String, dynamic>>.from(json.reaction),
      isConnected: true,
    );
  }
}
