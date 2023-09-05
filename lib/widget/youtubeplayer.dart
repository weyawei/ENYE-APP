
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class youtubePlayerView extends StatefulWidget {
  const youtubePlayerView({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<youtubePlayerView> createState() => _youtubePlayerViewState();
}

class _youtubePlayerViewState extends State<youtubePlayerView> {
  bool ytFullScreen = false;
  late YoutubePlayerController _controller;

  @override
  void initState(){
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(
        loop: true,
        autoPlay: false,
        forceHD: true,
      ),
    );
  }

  //to avoid memory use
  @override
  void deactivate(){
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        onEnterFullScreen: (){
          _controller.toggleFullScreenMode();
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: (){
            _controller.play();
          },
          bottomActions: [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            RemainingDuration(),
            PlaybackSpeedButton(),
          ],
        ),
        builder: (BuildContext context, player){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            height: MediaQuery.of(context).size.height * 0.35,
            child: FittedBox(
              fit: BoxFit.fill,
              child: VisibilityDetector(
                  key: Key('video-visibility-key'),
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction == 0.0) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  child: player
              ),
            )
          );
        }
    );
  }
}

