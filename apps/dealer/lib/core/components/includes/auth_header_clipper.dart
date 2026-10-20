import 'package:flutter/material.dart';

class HeaderArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 45)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width,
        size.height - 45,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
