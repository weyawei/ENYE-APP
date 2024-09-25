import 'package:flutter/material.dart';

import '../../../widget/widgets.dart';

class TimeCardPage extends StatelessWidget {
  final bool isPast;
  final child;

  const TimeCardPage({
    super.key,
    required this.isPast,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        child,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: fontSmallSize * 0.85,
          letterSpacing: 0.6,
          color: isPast ? Colors.grey : Colors.black
        ),
      ),
    );
  }
}
