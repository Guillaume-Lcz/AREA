import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reactobot/bloc/actions/actions_bloc.dart';
import 'package:reactobot/bloc/area/area_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';

import 'bloc/data/data_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'constantes.dart';
import 'is_connected.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            light: AppTheme.light,
            dark: AppTheme.dark,
          ),
        ),
        BlocProvider(
          create: (context) => ServiceBloc(),
        ),
        BlocProvider(
          create: (context) => ActionsBloc(),
        ),
        BlocProvider(
          create: (context) => DataBloc(),
        ),
        BlocProvider(
          create: (context) => AreaBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            theme: context.watch<ThemeBloc>().state.theme,
            home: const AuthPage(),
          );
        },
      ),
    );
  }
}
