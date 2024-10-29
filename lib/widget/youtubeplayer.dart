import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class youtubePlayerView extends StatefulWidget {
  const youtubePlayerView({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<youtubePlayerView> createState() => _youtubePlayerViewState();
}

class _youtubePlayerViewState extends State<youtubePlayerView> {
  late YoutubePlayerController _controller;
  bool _isInFullscreen = false; // Track fullscreen state

  @override
  void initState() {
    super.initState();

    // Initialize the YouTube controller with the given URL
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(
        loop: true,
        autoPlay: false,
        forceHD: true,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFullScreenDialog(BuildContext context, Duration currentPosition) {

    setState(() => _isInFullscreen = true); // Enter fullscreen
    // Lock the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _controller.pause();

    // Create a new controller for the dialog
    final dialogController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(
        loop: true,
        autoPlay: false, // Start playing automatically in fullscreen
        forceHD: true,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: YoutubePlayer(
              controller: dialogController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onReady: () {
                dialogController.seekTo(currentPosition); // Seek after the player is ready
              },
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    dialogController.pause();
                    _controller.seekTo(dialogController.value.position);
                    _controller.play();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() => _isInFullscreen = false); // Exit fullscreen

      _controller.seekTo(dialogController.value.position);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      _controller.play();
      dialogController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      height: MediaQuery.of(context).size.height * 0.3,
      child: FittedBox(
        fit: BoxFit.fill,
        child: VisibilityDetector(
          key: Key('system-video-visibility-key'),
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction == 0.0) {
              _controller.pause();
            } else if (!_isInFullscreen) {
              _controller.play();
            }
          },
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(isExpanded: true),
              RemainingDuration(),
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  _controller.pause();
                  _showFullScreenDialog(context, _controller.value.position);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
