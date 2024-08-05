import 'package:cached_network_image/cached_network_image.dart';
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
          child: Container(
            height: MediaQuery.of(context).size.height, // Specify a fixed height for the SizedBox
            child: RepaintBoundary(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  imagePath,
                ),
                backgroundDecoration: BoxDecoration(
                  color: Color(0xFFEAE7E6),
                ),
                loadingBuilder: (context, event) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.black, // Fallback color if image fails to load
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}