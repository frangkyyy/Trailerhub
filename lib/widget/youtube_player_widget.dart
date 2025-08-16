import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({Key? key, required this.youtubeKey})
      : super(key: key);

  final String youtubeKey;

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late final YoutubePlayerController _controller;

  //panggil initstate
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey, //key dari youtubenya
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //panggil YoutubePlayerBuilder
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        //atur rotasi manual
        SystemChrome.setPreferredOrientations([
          //tambahkan DeviceOrientation.landscapeLeft dan right
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      },
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [
            SystemUiOverlay.bottom,
            SystemUiOverlay.top,
          ],
        );
        SystemChrome.setPreferredOrientations([
          //tambahkan DeviceOrientation.landscapeLeft dan right
          DeviceOrientation.portraitUp,
        ]);
      },
      player: YoutubePlayer(controller: _controller),
      builder: (_, player) => player, //player itu player dari youtubenya
    );
  }

  //jangan lupa kalo widget ini sudah digunakan, kita dispose
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
