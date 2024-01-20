import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.submitData,
    required this.text,
  });

  final VoidCallback submitData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        submitData();
      },
      child: Text(text),
    );
  }
}
