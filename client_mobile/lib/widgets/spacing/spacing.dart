import 'package:flutter/material.dart';

class ScalablePadding extends StatelessWidget {
  final double scale;

  const ScalablePadding({Key? key, this.scale = 0.02}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(height: screenHeight * scale);
  }
}
