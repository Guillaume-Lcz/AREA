import 'package:flutter/material.dart';

class ErrorMessage {
  void snackBar({required context, required int errorCode, dynamic otherValue}) {
    String message;
    switch (errorCode) {
      case 0:
        message = "You can't delete an action if there is at least one reaction";
      case 400:
        message = "Bad request";
        break;
      case 401:
        message = "Unauthorized";
        break;
      case 409:
        message = "The user already exists";
        break;
      case 500:
        message = "Server error";
      case 501:
        message = "Server error";
      case 502:
        message = "Server error";
      case 503:
        message = "Server error";
        break;
      default:
        message = "Error not exist";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${otherValue ?? message}\nError code: $errorCode'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
