import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  FullScreenImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height, // Specify a fixed height for the SizedBox
            child: RepaintBoundary(
              child: PhotoView(
                imageProvider: NetworkImage(imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}