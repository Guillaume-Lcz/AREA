import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/data/data_bloc.dart';
import 'package:reactobot/features/account/pages/print_user_data.dart';

import '../../../bloc/theme/theme_bloc.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = context.watch<ThemeBloc>().state.theme.brightness;
    //final backgroundColor = brightness == Brightness.dark ? Colors.green : Colors.purple;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrintUserData(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: context.watch<DataBloc>().state.userData.name == null
                  ? const Icon(Icons.person, size: 50)
                  : Text(
                      context.watch<DataBloc>().state.userData.name![0],
                      style: const TextStyle(
                        fontSize: 60,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.watch<DataBloc>().state.userData.name ?? 'Anonymous',
            style: const TextStyle(
              fontSize: 24,
              //color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
