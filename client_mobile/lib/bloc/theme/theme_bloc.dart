import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeData light;
  final ThemeData dark;

  ThemeBloc({
    required this.light,
    required this.dark,
  }) : super(ThemeState(
          isOn: true,
          theme: light,
        )) {
    on<ThemeSubmitEvent>((ThemeSubmitEvent event, Emitter<ThemeState> emit) {
      final bool isOn = state.isOn;
      final ThemeData newTheme = isOn ? dark : light;

      emit(ThemeState(isOn: !isOn, theme: newTheme));
    });
  }
}
