import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/service/service_model.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    primaryColor: const Color(0xFF4FC3F7), // Bleu clair
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4FC3F7),
      secondary: Colors.orange,
    ),
    //fontFamily: 'LuckiestGuy',
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      color: Color(0xFF4FC3F7),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      fillColor: Colors.transparent,
      labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
      floatingLabelStyle: const TextStyle(color: Color(0xFF4FC3F7)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(const Color(0xFF4FC3F7)),
      trackColor: MaterialStateProperty.all(const Color(0xFF4FC3F7).withOpacity(0.5)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF4FC3F7),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.orange),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
        elevation: MaterialStateProperty.all(5),
        shadowColor: MaterialStateProperty.all(Colors.blueAccent),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF4FC3F7),
      unselectedItemColor: const Color(0xFF4FC3F7).withOpacity(0.5),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF4FC3F7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 4),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    primaryColor: const Color(0xFF26A69A),
    colorScheme: const ColorScheme.dark(primary: Color(0xFF26A69A), secondary: Color(0xFF15B232)),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      color: Color(0xFF26A69A),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF26A69A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      fillColor: Colors.transparent,
      labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
      floatingLabelStyle: const TextStyle(color: Color(0xFF26A69A)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(const Color(0xFF26A69A)),
      trackColor: MaterialStateProperty.all(const Color(0xFF26A69A).withOpacity(0.5)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF26A69A),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF15B232)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
        elevation: MaterialStateProperty.all(5),
        shadowColor: MaterialStateProperty.all(Colors.cyanAccent),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF26A69A),
      unselectedItemColor: const Color(0xFF26A69A).withOpacity(0.5),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF26A69A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.white, width: 4),
      ),
    ),
  );
}

extension CustomTheme on BuildContext {
  Color get borderColor =>
      (Theme.of(this).brightness == Brightness.dark) ? Colors.white : Colors.black;
}

List<CategoryModel> categories = <CategoryModel>[
  CategoryModel(
    service: 'Gmail',
    icon: FontAwesomeIcons.envelope,
    activate: false,
    isConnected: false,
    action: [
      {
        'name': 'last_mail',
        'description': 'Run reactions one time every day',
        'active': false,
        'data': [{}]
      },
      {
        'name': 'last_mail_from_someone',
        'description': 'Run reactions one time every month',
        'active': false,
        'data': [{}]
      },
    ],
    reaction: [
      {
        'name': 'send_mail',
        'description': 'Triggers when a song is added',
        'active': false,
        'data': [
          {
            'to': '',
            'subject': '',
            'body': '',
          },
        ]
      },
    ],
  ),
  CategoryModel(
    service: 'Discord',
    icon: FontAwesomeIcons.discord,
    activate: false,
    color: const Color(0xFF7289da),
    isConnected: false,
    action: [
      {
        'name': 'new_message_received',
        'description': 'A new message is received',
        'active': false,
        'data': [{}]
      },
      {
        'name': 'new_server_joined',
        'description': 'A new server is joined',
        'active': false,
        'data': [{}]
      },
    ],
    reaction: [
      {
        'name': 'post_message',
        'description': 'Posts a message in a specific location',
        'active': false,
        'data': [
          {
            'channel_id': '',
            'body': '',
          },
        ],
      },
    ],
  ),
  CategoryModel(
    service: 'Spotify',
    icon: FontAwesomeIcons.spotify,
    activate: false,
    color: const Color(0xFF81b71a),
    isConnected: false,
    action: [
      {
        'name': 'last_playlist',
        'description': 'Triggers when a playlist is added',
        'active': false,
        'data': [{}]
      },
      {
        'name': 'last_song',
        'description': 'Triggers when a song is listened',
        'active': false,
        'data': [{}]
      },
      {
        'name': 'last_album',
        'description': 'Triggers when a album is added',
        'active': false,
        'data': [{}]
      },
    ],
    reaction: [],
  ),
  CategoryModel(
    service: 'Timer',
    icon: FontAwesomeIcons.hourglass,
    activate: false,
    color: Colors.transparent,
    isConnected: false,
    action: [
      {
        'name': 'every_day',
        'description': 'Run reactions one time every day',
        'active': false,
        'data': [
          {"minute": 0, "hour": 0, "day": 0},
        ],
      },
      {
        'name': 'every_month',
        'description': 'Run reactions one time every month',
        'active': false,
        'data': [
          {"minute": 0, "hour": 0, "day": 0},
        ],
      },
    ],
    reaction: [],
  ),
];
