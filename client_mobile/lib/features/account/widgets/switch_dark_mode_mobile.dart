import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme/theme_bloc.dart';
import '../../../bloc/theme/theme_event.dart';

class SwitchDarkMode extends StatelessWidget {
  const SwitchDarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: !context.watch<ThemeBloc>().state.isOn,
        onChanged: (bool value) {
          context.read<ThemeBloc>().add(ThemeSubmitEvent());
        },
      ),
    );
  }
}
