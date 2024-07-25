import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color clr;
  final double fontSize;

  const customButton({super.key, required this.onTap, required this.text, required this.clr, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: MediaQuery.of(context).size.height * 0.065,
        width: MediaQuery.of(context).size.width * 0.88,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: clr),
          borderRadius: BorderRadius.circular(25),
          color: clr,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              letterSpacing: 1.5
            ),
          ),
        ),
      ),
    );
  }
}