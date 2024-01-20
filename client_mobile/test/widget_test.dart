import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactobot/bloc/actions/actions_bloc.dart';
import 'package:reactobot/bloc/data/data_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';
import 'package:reactobot/bloc/theme/theme_bloc.dart';
import 'package:reactobot/is_connected.dart';
import 'package:reactobot/main.dart';

void main() {
  group('App Initialization', () {
    testWidgets('App should initialize and display AuthPage', (WidgetTester tester) async {
      // Simule l'initialisation de l'application
      await tester.pumpWidget(const MyApp());

      // Vérifie si AuthPage est présent
      expect(find.byType(AuthPage), findsOneWidget);
    });

    testWidgets('BlocProviders should be initialized', (WidgetTester tester) async {
      // Simule l'initialisation de l'application
      await tester.pumpWidget(const MyApp());

      // Vérifie si les BlocProviders sont présents
      expect(find.byType(BlocProvider<ThemeBloc>), findsWidgets);
      expect(find.byType(BlocProvider<ServiceBloc>), findsWidgets);
      expect(find.byType(BlocProvider<ActionsBloc>), findsWidgets);
      expect(find.byType(BlocProvider<DataBloc>), findsWidgets);
      // Répétez pour les autres BlocProviders
    });
  });
}
