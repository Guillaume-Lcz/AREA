import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.isOn,
    required this.theme,
  });

  final bool isOn;
  final ThemeData theme;

  @override
  List<Object> get props => [isOn, theme];
}
