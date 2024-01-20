// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reactobot/widgets/auth_services/choose_service_to_connect.dart';
//
// import '../../../bloc/data/data_bloc.dart';
// import '../../../bloc/service/service_bloc.dart';
// import '../../../bloc/service/service_model.dart';
// import '../../../widgets/display_logo/display_logo.dart';
// import '../widgets/connexion_indicator.dart';
// import '../widgets/display_actions.dart';
// import '../widgets/display_reactions.dart';
//
// class ServiceCategoryPage extends StatelessWidget {
//   const ServiceCategoryPage({
//     super.key,
//     required this.map,
//     required this.index,
//   });
//
//   final List<CategoryModel> map;
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: BlocBuilder<ServiceBloc, ServiceState>(
//         builder: (BuildContext context, ServiceState state) {
//           return Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Switch(
//                     value: state.initialList[index].isConnected,
//                     onChanged: (bool value) async {
//                       final serviceConnector = ChooseServiceToConnect(context: context);
//                       bool shouldToggle = false;
//                       if (context.read<DataBloc>().state.userData.id == null) {
//                         context.read<ServiceBloc>().add(SwitchIsConnected(index: index));
//                       } else if (await serviceConnector.discord(state, index, value) == true) {
//                         print('faire discord');
//                         shouldToggle = true;
//                       } else if (await serviceConnector.spotify(state, index, value) == true) {
//                         print('faire spotify');
//                         shouldToggle = true;
//                       }
//                       if (shouldToggle) {
//                         print('ouiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
//                         context.read<ServiceBloc>().add(SwitchIsConnected(index: index));
//                       }
//                     },
//                   ),
//                   Text(
//                     map[index].isConnected ? 'You are connected' : 'You are not connected',
//                   ),
//                   ConnectionIndicator(isConnected: map[index].isConnected),
//                 ],
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: MediaQuery.of(context).size.height / 5),
//                     logo(map[index], context),
//                     const SizedBox(height: 16),
//                     Text(
//                       map[index].service,
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     if (!context.read<ServiceBloc>().state.isOn) const Text('Action'),
//                     const SizedBox(height: 8),
//                     if (!context.read<ServiceBloc>().state.isOn)
//                       DisplayActions(
//                         map: map,
//                         index: index,
//                       ),
//                     if (context.watch<ServiceBloc>().state.isOn) const Text('Reaction'),
//                     if (context.watch<ServiceBloc>().state.isOn)
//                       DisplayReaction(
//                         map: map,
//                         index: index,
//                       ),
//                   ],
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/widgets/auth_services/choose_service_to_connect.dart';

import '../../../bloc/data/data_bloc.dart';
import '../../../bloc/service/service_bloc.dart';
import '../../../bloc/service/service_model.dart';
import '../../../widgets/display_logo/display_logo.dart';
import '../widgets/connexion_indicator.dart';
import '../widgets/display_actions.dart';
import '../widgets/display_reactions.dart';

class ServiceCategoryPage extends StatelessWidget {
  const ServiceCategoryPage({
    super.key,
    required this.map,
    required this.index,
  });

  final List<CategoryModel> map;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Switch(
                value: context.watch<ServiceBloc>().state.initialList[index].isConnected,
                onChanged: (bool value) async {
                  final serviceConnector = ChooseServiceToConnect(context: context);
                  bool shouldToggle = false;
                  if (context.read<DataBloc>().state.userData.id == null) {
                    context.read<ServiceBloc>().add(SwitchIsConnected(index: index));
                  } else if (await serviceConnector.discord(index, value) == true) {
                    shouldToggle = true;
                  } else if (await serviceConnector.spotify(index, value) == true) {
                    shouldToggle = true;
                  } else if (await serviceConnector.google(index, value) == true) {
                    shouldToggle = true;
                  }
                  if (shouldToggle) {
                    if (!context.mounted) return;
                    context.read<ServiceBloc>().add(SwitchIsConnected(index: index));
                  }
                },
              ),
              Text(
                map[index].isConnected ? 'You are connected' : 'You are not connected',
              ),
              ConnectionIndicator(isConnected: map[index].isConnected),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 5),
                logo(map[index], context),
                const SizedBox(height: 16),
                Text(
                  map[index].service,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                if (!context.read<ServiceBloc>().state.isOn) const Text('Action'),
                const SizedBox(height: 8),
                if (!context.read<ServiceBloc>().state.isOn)
                  DisplayActions(
                    map: map,
                    index: index,
                  ),
                if (context.watch<ServiceBloc>().state.isOn) const Text('Reaction'),
                if (context.watch<ServiceBloc>().state.isOn)
                  DisplayReaction(
                    map: map,
                    index: index,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
