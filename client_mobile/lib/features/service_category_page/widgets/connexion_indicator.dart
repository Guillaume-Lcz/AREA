import 'package:flutter/material.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({super.key, required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
