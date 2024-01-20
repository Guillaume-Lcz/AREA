import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/data/data_bloc.dart';
import '../../../bloc/data/data_model.dart';
import '../../../bloc/service/service_bloc.dart';
import '../../account/pages/account_mobile.dart';
import '../../action/pages/action.dart';
import '../../home/pages/home_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ConfigureActionPage(),
    Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData servicesConnected = context.watch<DataBloc>().state.userData;
    if (servicesConnected.isDiscordAuth == true) {
      context.watch<ServiceBloc>().add(const ToggleServiceConnexion(serviceName: "Discord"));
    }
    if (servicesConnected.isSpotifyAuth == true) {
      context.watch<ServiceBloc>().add(const ToggleServiceConnexion(serviceName: "Spotify"));
    }
    if (servicesConnected.isGoogleAuth == true) {
      context.watch<ServiceBloc>().add(const ToggleServiceConnexion(serviceName: "Gmail"));
    }
    context.watch<ServiceBloc>().add(const ToggleServiceConnexion(serviceName: "Timer"));

    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Compte',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
