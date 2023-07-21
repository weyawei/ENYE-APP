
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class videoPlayerView extends StatefulWidget {
  const videoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
  });

  final String url;
  final DataSourceType dataSourceType;

  @override
  State<videoPlayerView> createState() => _videoPlayerViewState();
}

class _videoPlayerViewState extends State<videoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;


  @override
  void initState(){
    super.initState();

    switch (widget.dataSourceType){
      case DataSourceType.asset :
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network :
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case DataSourceType.file :
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri :
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    _chewieController = ChewieController(
      autoInitialize: true,
      allowPlaybackSpeedChanging: false,
      showOptions: false,
      showControls: true,
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16/9,
    );
  }

  //to avoid memory use
  @override
  void dispose(){
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: VisibilityDetector(
        key: Key('video-visibility-key'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 0.0) {
            _videoPlayerController.pause();
          } else {
            _videoPlayerController.play();
          }
        },
        child: AspectRatio(
          aspectRatio: 16/9,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
