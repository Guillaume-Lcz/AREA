import 'package:flutter/material.dart';

import 'features/bottom_navigation_bar/pages/bottom_navigation_bar_mobile.dart';
import 'features/log_page/pages/login_page_mobile.dart';
import 'widgets/user_requests/user_requests.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserRequests(context: context).getUser(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return const BottomBar();
          } else {
            return const LoginPage();
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
