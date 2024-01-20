import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  const SquareTile({
    super.key,
    required this.imagePath,
    this.onTap,
    this.elevation = 2.0,
  });

  final String imagePath;
  final Function()? onTap;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: Image.asset(
            imagePath,
            height: 40,
          ),
        ),
      ),
    );
  }
}
