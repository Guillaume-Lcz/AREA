import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/data/data_bloc.dart';
import '../../../widgets/local_storage/send_get_from_local_storage.dart';

class Disconnect extends StatelessWidget {
  const Disconnect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Disconnect'),
      trailing: OutlinedButton(
        onPressed: () {
          context.read<DataBloc>().add(const ProcessIsDiconnect(isDiconnect: true));
          LocalStorage().removeValue('token');
        },
        child: const Text('Disconnect'),
      ),
    );
  }
}
