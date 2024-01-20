import 'package:flutter/material.dart';

class TextFieldConnexionPage extends StatefulWidget {
  const TextFieldConnexionPage({
    super.key,
    required this.text,
    required this.isObscure,
    required this.controller,
    required this.showError,
    required this.icon,
    required this.textInputAction,
  });

  final String text;
  final bool isObscure;
  final TextEditingController controller;
  final bool showError;
  final Icon icon;
  final TextInputAction textInputAction;

  @override
  TextFieldConnexionPageState createState() => TextFieldConnexionPageState();
}

class TextFieldConnexionPageState extends State<TextFieldConnexionPage> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        suffixIcon: widget.isObscure
            ? IconButton(
                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        errorText: widget.showError ? 'Ce champ est obligatoire' : null,
        hintText: widget.text,
        labelText: widget.text,
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
