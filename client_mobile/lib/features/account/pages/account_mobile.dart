import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';

import '../../../bloc/actions/actions_bloc.dart';
import '../../../bloc/area/area_bloc.dart';
import '../../../bloc/data/data_bloc.dart';
import '../../../is_connected.dart';
import '../widgets/disconnect.dart';
import '../widgets/header.dart';
import '../widgets/switch_dark_mode_mobile.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DataBloc, DataState>(
      listener: (context, state) {
        if (state.isDisconnect) {
          context.read<ActionsBloc>().add(const ResetActionsEvent());
          context.read<DataBloc>().add(const ResetUserData());
          context.read<ServiceBloc>().add(const SetAllServicesDisconnected());
          context.read<DataBloc>().add(const ProcessIsDiconnect(isDiconnect: false));
          context.read<AreaBloc>().add(const ProcessResetAreaDataModel());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AuthPage(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        body: ListView(
          children: [
            const BuildHeader(),
            const SizedBox(height: 16),
            _appearance(context),
            _disconnect(context),
          ],
        ),
      ),
    );
  }

  Widget _appearance(context) {
    return const ExpansionTile(
      title: Text('Appearance'),
      leading: Icon(Icons.brightness_2),
      children: <Widget>[
        SwitchDarkMode(),
      ],
    );
  }

  Widget _disconnect(context) {
    return const ExpansionTile(
      title: Text('Disconnect'),
      leading: Icon(Icons.exit_to_app),
      children: <Widget>[
        Disconnect(),
      ],
    );
  }
}
