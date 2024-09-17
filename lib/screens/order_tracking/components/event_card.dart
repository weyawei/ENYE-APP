
import 'package:flutter/material.dart';

class EventCardPage extends StatelessWidget {
  final bool isPast;
  final child;

  const EventCardPage({
    super.key,
    required this.isPast,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.025),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: isPast ? Colors.deepOrange.shade300 : Colors.deepOrange.shade100,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: child
    );
  }
}
