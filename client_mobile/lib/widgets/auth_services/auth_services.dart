/*
class AuthServices extends StatefulWidget {
  const AuthServices({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;

  @override
  State<AuthServices> createState() => _AuthServicesState();
}

class _AuthServicesState extends State<AuthServices> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 2,
            child: WebViewWidget(
              controller: widget.webViewController,
            ),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthServices extends StatefulWidget {
  const AuthServices({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;

  @override
  State<AuthServices> createState() => _AuthServicesState();
}

class _AuthServicesState extends State<AuthServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: WebViewWidget(
        controller: widget.webViewController,
      ),
    );
  }
}
