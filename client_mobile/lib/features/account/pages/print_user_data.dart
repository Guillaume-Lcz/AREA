import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/data/data_bloc.dart';
import '../../../widgets/local_storage/send_get_from_local_storage.dart';

class PrintUserData extends StatelessWidget {
  const PrintUserData({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<DataBloc>().state.userData;

    if (userData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Account'),
          centerTitle: true,
        ),
        body: const Center(child: Text('No user data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textColored('Name', userData.name ?? 'N/A'),
                      const SizedBox(height: 12),
                      _textColored('Email', userData.email ?? 'N/A'),
                      const SizedBox(height: 12),
                      _textColored(
                          'Google Auth', userData.isGoogleAuth == true ? 'Enabled' : 'Disabled'),
                      const SizedBox(height: 12),
                      _textColored(
                          'Discord Auth', userData.isDiscordAuth == true ? 'Enabled' : 'Disabled'),
                      const SizedBox(height: 12),
                      _textColored(
                          'Spotify Auth', userData.isSpotifyAuth == true ? 'Enabled' : 'Disabled'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<DataBloc>().add(const ProcessIsDiconnect(isDiconnect: true));
                  LocalStorage().removeValue('token');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textColored(String name, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        children: [
          TextSpan(
            text: '$name: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}
