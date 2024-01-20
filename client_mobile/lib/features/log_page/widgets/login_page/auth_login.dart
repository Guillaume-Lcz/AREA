import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../bottom_navigation_bar/pages/bottom_navigation_bar_mobile.dart';

Future<dynamic> getApiData() async {
  Uri url = Uri.parse('${dotenv.env['CLIENT_URL']}/auth/local/sign-in');
  print(json.encode({'email': "user2@example.com", 'password': 'password123'}));
  http.Response response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(<String, String>{"email": "user2@example.com", "password": "password123"}),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

FutureBuilder displayApiData(context) {
  return FutureBuilder(
    future: getApiData(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return const BottomBar();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}
