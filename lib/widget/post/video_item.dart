import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const VideoItem({@required this.videoPlayerController, this.looping});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {

  ChewieController _chewieController;

  Future<void> _future;

  Future<void> initVideoPlayer() async {
    await widget.videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        looping: widget.looping,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitDown],
        deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitDown],
        fullScreenByDefault: true,
        showOptions: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Center(
          child: snapshot.connectionState == ConnectionState.waiting ? 
            const CircularProgressIndicator() : Chewie(controller: _chewieController,),
        );
      }
    );
  }
}