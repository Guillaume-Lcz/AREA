import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../widgets/local_storage/send_get_from_local_storage.dart';
import '../../../widgets/spacing/spacing.dart';
import '../../../widgets/user_requests/user_requests.dart';
import '../../bottom_navigation_bar/pages/bottom_navigation_bar_mobile.dart';
import '../widgets/add_server_url.dart';
import '../widgets/login_page/google_login_mobile.dart';
import '../widgets/login_page/login_button_mobile.dart';
import '../widgets/text_field_connexion_page_mobile.dart';
import 'login_page_mobile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();

  bool _emailShowError = false;
  bool _passwordShowError = false;
  bool _nameShowError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitData() async {
    setState(() {
      _emailShowError = _emailController.text.isEmpty;
      _passwordShowError = _passwordController.text.isEmpty;
      _nameShowError = _nameController.text.isEmpty;
    });

    if (!_emailShowError && !_passwordShowError && !_nameShowError) {
      UserRequests(context: context).userRegister(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create an account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
              if (!context.mounted) return;
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SendServerUrl(url: url ?? '');
                },
              );
            },
            icon: const Icon(FontAwesomeIcons.server),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ScalablePadding(scale: .04),
                  TextFieldConnexionPage(
                    text: 'Name',
                    isObscure: false,
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    showError: _nameShowError,
                    icon: const Icon(FontAwesomeIcons.user),
                  ),
                  const ScalablePadding(scale: .02),
                  TextFieldConnexionPage(
                    text: 'Email',
                    isObscure: false,
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    showError: _emailShowError,
                    icon: const Icon(Icons.alternate_email),
                  ),
                  const ScalablePadding(scale: .02),
                  TextFieldConnexionPage(
                    text: 'Password',
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                    controller: _passwordController,
                    showError: _passwordShowError,
                    icon: const Icon(Icons.lock),
                  ),
                  const ScalablePadding(scale: .04),
                  LoginButton(
                    submitData: _submitData,
                    text: 'Register',
                  ),
                  const ScalablePadding(scale: .04),
                  const Text('Or, register with...', style: TextStyle(fontSize: 12)),
                  const ScalablePadding(scale: .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        imagePath: 'assets/images/google_logo.png',
                        onTap: () async {
                          await UserRequests(context: context).loginWithGoogle(true);
                        },
                      ),
                      const SizedBox(width: 10),
                      SquareTile(
                        imagePath: 'assets/images/anonymous_login.png',
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const BottomBar()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                  const ScalablePadding(scale: .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Already have an account ? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextButton(
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                          debugPrint('Login');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
