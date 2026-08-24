import 'package:flutter/material.dart';

class HeaderArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height + 42,
        size.width,
        size.height - 78,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
