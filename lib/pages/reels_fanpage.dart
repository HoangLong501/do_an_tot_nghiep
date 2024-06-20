import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelFanPage extends StatefulWidget {
  const ReelFanPage({super.key});

  @override
  State<ReelFanPage> createState() => _FanPageState();
}

class _FanPageState extends State<ReelFanPage> {
  VideoPlayerController? _controller ;


  onLoad()async{

    print(_controller!.value);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }


}
