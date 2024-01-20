import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:reactobot/bloc/area/area_bloc.dart';
import 'package:reactobot/bloc/data/data_bloc.dart';

import '../../features/bottom_navigation_bar/pages/bottom_navigation_bar_mobile.dart';
import '../error_message/error_message.dart';
import '../local_storage/send_get_from_local_storage.dart';

class UserRequests {
  const UserRequests({this.context});

  final BuildContext? context;

  void _handleData(http.Response response) {
    Map<String, dynamic> data = json.decode(response.body);
    context!.read<DataBloc>().add(ProcessReceivedData(data: data));
  }

  void _handleAreaData(String response) {
    context!.read<AreaBloc>().add(ProcessReceivedAreaData(data: response));
  }

  void _showDialog() {
    showDialog(
      context: context!,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _push() {
    Navigator.pop(context!);
    Navigator.of(context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BottomBar()),
      (Route<dynamic> route) => false,
    );
  }

  void _error({int statusCode = -1, dynamic otherValue}) {
    Navigator.pop(context!);
    ErrorMessage().snackBar(context: context, errorCode: statusCode, otherValue: otherValue);
  }

  Future<String> getGoogleAuthUrl() async {
    _showDialog();
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/auth/google/url?mobile=true');
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body)['url'] ?? '';
      } else {
        _error(
          statusCode: response.statusCode,
          otherValue: json.decode(response.body)['message'] ?? '',
        );
        return '';
      }
    } catch (e) {
      _error(otherValue: 'Bad url or server down');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<bool> loginWithGoogle(bool redirect) async {
    try {
      String authUrl = await getGoogleAuthUrl();
      if (authUrl.isEmpty) return false;
      final String result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: 'reactobot',
      );
      final String? token = Uri.parse(result).queryParameters['token'];
      LocalStorage().saveStringToLocalStorage('token', "token=$token");
      if (await getUser() == true) {
        if (redirect) {
          _push();
        }
      }
      return true;
    } catch (e) {
      throw Exception('Error during authentication: $e');
    }
  }

  Future<void> userLogin(String email, String password) async {
    _showDialog();
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }

    try {
      Uri uri = Uri.parse('$url/auth/local/sign-in?mobile=true');
      http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          <String, String>{
            "email": email,
            'password': password,
          },
        ),
      );

      if (response.statusCode == 201) {
        String? sessionCookie;
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          sessionCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
        }
        LocalStorage().saveStringToLocalStorage('token', sessionCookie!);
        if (await getUser() == true) {
          _push();
        }
      } else {
        _error(
          statusCode: response.statusCode,
          otherValue: json.decode(response.body)['message'] ?? '',
        );
      }
    } catch (e) {
      _error(otherValue: 'Bad url or server down');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> userRegister(String name, String email, String password) async {
    _showDialog();
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/auth/local/sign-up?mobile=true');
      http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          <String, String>{
            'email': email,
            'password': password,
            'name': name,
          },
        ),
      );
      if (response.statusCode == 201) {
        String? sessionCookie;
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          sessionCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
        }
        LocalStorage().saveStringToLocalStorage("token", sessionCookie!);
        if (await getUser() == true) {
          _push();
        }
      } else {
        _error(
          statusCode: response.statusCode,
          otherValue: json.decode(response.body)['message'] ?? '',
        );
      }
    } catch (e) {
      _error(otherValue: 'Bad url or server down');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<bool> getUser() async {
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/user');
      http.Response response = await http.get(
        uri,
        headers: {
          'cookie': userAuthToken ?? '',
        },
      );
      if (response.statusCode == 200) {
        if (await getArea()) {
          _handleData(response);
        } else {
          return false;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<bool> deleteUser() async {
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/user/delete');
      http.Response response = await http.delete(
        uri,
        headers: {
          'cookie': userAuthToken ?? '',
        },
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        debugPrint('Failed to delete the user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete the user. Error:');
    }
    return false;
  }

  Future<bool> createNewArea(String body) async {
    _showDialog();
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    Uri uri = Uri.parse('$url/project');
    try {
      http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'cookie': userAuthToken ?? '',
        },
        body: body,
      );
      if (response.statusCode == 201) {
        debugPrint('Area created');
        Navigator.pop(context!);
        return true;
      } else {
        _error(
          statusCode: response.statusCode,
          otherValue: json.decode(response.body)['message'] ?? '',
        );
        return false;
      }
    } catch (e) {
      _error(otherValue: 'Bad url or server down');
      throw Exception('Caught error: $e');
    }
  }

  Future<bool> getArea() async {
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/project');
      http.Response response = await http.get(
        uri,
        headers: {
          'cookie': userAuthToken ?? '',
        },
      );
      if (response.statusCode == 200) {
        _handleAreaData(response.body);
        return true;
      } else {
        debugPrint('Failed to get the area: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get the area. Error:');
    }
    return false;
  }

  Future<bool> deleteArea(String idTodelete) async {
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/project/$idTodelete');
      http.Response response = await http.delete(
        uri,
        headers: {
          'cookie': userAuthToken ?? '',
        },
      );
      if (response.statusCode == 204) {
        _handleAreaData(response.body);
        return true;
      } else {
        debugPrint('Failed to delete the area: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete the area. Error:');
    }
    return false;
  }

  Future<http.Response> getServiceAuthUrl(String service) async {
    final String? userAuthToken = await LocalStorage().getStringFromLocalStorage('token');
    String? url = await LocalStorage().getStringFromLocalStorage('urlServer');
    if (url != null && url.isEmpty) {
      url = dotenv.env['CLIENT_URL'];
    }
    try {
      Uri uri = Uri.parse('$url/$service');
      http.Response response = await http.get(
        uri,
        headers: {
          'cookie': userAuthToken ?? '',
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to get $service Auth URL: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get $service. Error: ');
    }
  }

  Future<String> loginWithService(String service) async {
    try {
      http.Response response = await getServiceAuthUrl('services');
      return json.decode(response.body)[service]['redirect'] ?? '';
    } catch (e) {
      _error(otherValue: 'Error during authentication: $e');
      throw Exception('Error during authentication: $e');
    }
  }
}
