import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactobot/bloc/service/service_bloc.dart';

import '../widgets/service_card.dart';

class Services extends StatelessWidget {
  const Services({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: context.watch<ServiceBloc>().state.initialList.length,
        itemBuilder: (BuildContext context, int index) {
          return ServicesCard(
            map: context.watch<ServiceBloc>().state.initialList,
            index: index,
          );
        },
      ),
    );
  }
}
