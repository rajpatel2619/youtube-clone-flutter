import 'package:flutter/material.dart';
import 'package:youtube_crunk_studios/model/videos_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({this.videoItem});
  final VideoItem videoItem;
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController _controller;
  bool _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(
        initialVideoId: widget.videoItem.video.resourceId.videoId,
        flags: YoutubePlayerFlags(
          // mute: false,
          autoPlay: true,
          
        ))
      ..addListener(_listner);
  }

  void _listner() {
    // if(_isPlayerReady && mounted)
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

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
              title: Text(widget.videoItem.video.title),
            ),
      body: Container(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('player is ready');
            _isPlayerReady = true;
          },
        ),
      ),
    );
  }
}