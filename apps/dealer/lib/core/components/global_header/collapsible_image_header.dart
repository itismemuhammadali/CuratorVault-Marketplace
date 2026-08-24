import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CollapsibleImageHeader extends StatefulWidget {
  final String image;
  final double maxHeight;
  final double minHeight;

  const CollapsibleImageHeader({
    super.key,
    required this.image,
    this.maxHeight = 340,
    this.minHeight = 200,
  });

  @override
  State<CollapsibleImageHeader> createState() =>
      _CollapsibleImageHeaderState();
}

class _CollapsibleImageHeaderState
    extends State<CollapsibleImageHeader> {

  double _currentHeight = 0;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.maxHeight;


  }

  @override
  Widget build(BuildContext context) {
    double percent =
        (_currentHeight - widget.minHeight) /
            (widget.maxHeight - widget.minHeight);

    return SizedBox(
      height: _currentHeight,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r * percent),
          bottomRight: Radius.circular(40.r * percent),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black.withValues(alpha: 0.30),
            ),
          ],
        ),
      ),
    );
  }
}
