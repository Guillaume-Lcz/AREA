import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../bloc/data/data_bloc.dart';
import '../../bloc/service/service_bloc.dart';
import '../local_storage/send_get_from_local_storage.dart';
import '../user_requests/user_requests.dart';
import 'auth_services.dart';

class ChooseServiceToConnect {
  const ChooseServiceToConnect({
    required this.context,
  });

  final BuildContext context;

  WebViewController controller(String token, String url) {
    final WebViewController webViewController = WebViewController();
    WebViewCookie cookie = WebViewCookie(
      name: 'token',
      value: token,
      domain: dotenv.env['CLIENT_URL']!,
    );

    WebViewCookieManager().setCookie(cookie);
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.loadRequest(Uri.parse(url));
    return webViewController;
  }

  Future<bool> discord(int index, bool value) async {
    if (!context.read<DataBloc>().state.userData.isDiscordAuth! && value) {
      if (context.read<ServiceBloc>().state.initialList[index].service == 'Discord') {
        final BuildContext localContext = context;
        String? token = await LocalStorage().getStringFromLocalStorage('token');
        token = token?.replaceFirst('token=', '');
        String url = await const UserRequests().loginWithService('discord');
        if (!localContext.mounted) return false;

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthServices(
              webViewController: controller(token ?? '', url),
            ),
          ),
        );
        if (!context.mounted) return false;
        if (await UserRequests(context: context).getUser() == true) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    }
    return false;
  }

  Future<bool> spotify(int index, bool value) async {
    if (!context.read<DataBloc>().state.userData.isDiscordAuth! && value) {
      if (context.read<ServiceBloc>().state.initialList[index].service == 'Spotify') {
        final BuildContext localContext = context;
        String? token = await LocalStorage().getStringFromLocalStorage('token');
        token = token?.replaceFirst('token=', '');
        String url = await const UserRequests().loginWithService('spotify');
        if (!localContext.mounted) return false;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthServices(
              webViewController: controller(token ?? '', url),
            ),
          ),
        );
        if (!context.mounted) return false;
        if (await UserRequests(context: context).getUser() == true) {
          if (!context.mounted) return false;
          context.read<DataBloc>().state.isLoading;
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> google(int index, bool value) async {
    if (!context.read<DataBloc>().state.userData.isGoogleAuth! && value) {
      if (context.read<ServiceBloc>().state.initialList[index].service == 'Gmail') {
        if (await UserRequests(context: context).loginWithGoogle(false) == true) {
          if (!context.mounted) return false;
          Navigator.pop(context);
          return true;
        }
      }
      return false;
    }
    return false;
  }
}
