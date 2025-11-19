
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasgidi/widgets/home.dart';
import 'package:lasgidi/widgets/home_page.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoLiveStream extends StatefulWidget {
  const VideoLiveStream({Key? key}) : super(key: key);

  @override
  _VideoLiveStreamState createState() => _VideoLiveStreamState();
}

class _VideoLiveStreamState extends State<VideoLiveStream> {
  VideoPlayerController? _controller;

  Future setPortrait() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Future setLandscape() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Future setPortraitAndLandscape() =>
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);


  @override
  void initState() {
    super.initState();
    stopAudioPlayer();
    WakelockPlus.enable();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://ngvid.elektranbroadcast.com/hls/lasgidi/mystream.m3u8'))
      ..initialize().then((_) {
        _controller!.play();
        setLandscape();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: (){
          //_showAlertConfirmDelete(context);
          _onWillPop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: const Color(0xff000000),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios)),
            title: const Text('Livestream'),
          ),
          body: Center(
            child: _controller!.value.isInitialized
                ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    VideoPlayer(_controller!),
                    //_ControlsOverlay(controller: _controller!),
                    VideoProgressIndicator(_controller!,
                      allowScrubbing: true,
                    ),
                  ],
                ))
                : const Text('Loading ...', style: TextStyle(color: Colors.white)),
          ),

/*floatingActionButton: FloatingActionButton(
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
          ),*/

        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setPortrait();
    WakelockPlus.disable();
    _controller!.dispose();
  }

  stopAudioPlayer(){
    const HomePage().stopAudio();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Color(0xff264796),
        title: new Text('Lasgidi Studio', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
        content: new Text('Do you really want to quit watching?', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('NO', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
          ),
          TextButton(
            onPressed: () => {
              setPortrait(),
              _controller!.dispose(),
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => const Home()))
              //Navigator.of(context).pop(true)
            },
            child: new Text('YES', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
          ),
        ],
      ),
    )) ?? false;
  }
}








/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lasgidi/widgets/home_page.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class VideoLiveStream extends StatefulWidget {
  const VideoLiveStream({Key? key}) : super(key: key);

  @override
  State<VideoLiveStream> createState() => _VideoLiveStreamState();
}

class _VideoLiveStreamState extends State<VideoLiveStream> {
  bool fullscreen = false;

  stopAudioPlayer(){
    const HomePage().stopAudio();
  }

  @override
  void initState() {
    stopAudioPlayer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: fullscreen == false
            ? AppBar(
          backgroundColor: const Color(0xff000000),
          */
/*title: const Image(
            image: AssetImage('assets/logoMain3.png'),
            fit: BoxFit.fitHeight,
            height: 50,
          ),*//*

          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
            : null,
        body: Padding(
          padding:
          fullscreen ? EdgeInsets.zero : const EdgeInsets.only(top: 32.0),
          child: YoYoPlayer(
            aspectRatio: 16 / 9,
            url: "https://video.servoserver.com.ng/lasgidifm/livestream.m3u8",
            allowCacheFile: true,
            videoStyle: const VideoStyle(
              qualityStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              forwardAndBackwardBtSize: 30.0,
              playButtonIconSize: 40.0,
              playIcon: Icon(
                Icons.add_circle_outline_outlined,
                size: 40.0,
                color: Colors.white,
              ),
              pauseIcon: Icon(
                Icons.remove_circle_outline_outlined,
                size: 40.0,
                color: Colors.white,
              ),
              videoQualityPadding: EdgeInsets.all(5.0),
              // showLiveDirectButton: true,
              // enableSystemOrientationsOverride: false,
            ),
            videoLoadingStyle: const VideoLoadingStyle(
              loading: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/logoMain3.png'),
                      fit: BoxFit.fitHeight,
                      height: 50,
                    ),
                    SizedBox(height: 16.0),
                    CupertinoActivityIndicator(radius: 50.0, color: Colors.white),
                    Text('Stream Loading ... Lasgidi 90.1 FM', style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
            onFullScreen: (value) {
              setState(() {
                if (fullscreen != value) {
                  fullscreen = value;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
*/



// Original

/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasgidi/widgets/home.dart';
import 'package:lasgidi/widgets/home_page.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoLiveStream extends StatefulWidget {
  const VideoLiveStream({Key? key}) : super(key: key);

  @override
  _VideoLiveStreamState createState() => _VideoLiveStreamState();
}

class _VideoLiveStreamState extends State<VideoLiveStream> {
  VideoPlayerController? _controller;

  Future setPortrait() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Future setLandscape() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Future setPortraitAndLandscape() =>
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);


  @override
  void initState() {
    super.initState();
    stopAudioPlayer();
    WakelockPlus.enable();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://video.servoserver.com.ng/lasgidifm/livestream.m3u8'))
      ..initialize().then((_) {
        _controller!.play();
        setLandscape();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GestureDetector(
          onTap: (){
            //_showAlertConfirmDelete(context);
            _onWillPop(context);
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: _controller!.value.isInitialized
                  ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(_controller!),
                      //_ControlsOverlay(controller: _controller!),
                      VideoProgressIndicator(_controller!,
                        allowScrubbing: true,
                      ),
                    ],
                  ))
                  : const Text('Loading ...', style: TextStyle(color: Colors.white)),
            ),

/*floatingActionButton: FloatingActionButton(
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
            ),*/

          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    setPortrait();
    WakelockPlus.disable();
    _controller!.dispose();
  }

  stopAudioPlayer(){
    const HomePage().stopAudio();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Color(0xff264796),
        title: new Text('Lasgidi Studio', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
        content: new Text('Do you really want to quit watching?', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('NO', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
          ),
          TextButton(
            onPressed: () => {
              setPortrait(),
              _controller!.dispose(),
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => const Home()))
              //Navigator.of(context).pop(true)
            },
            child: new Text('YES', style: TextStyle(color: Colors.white, fontFamily: 'Gotham XLight')),
          ),
        ],
      ),
    )) ?? false;
  }
}




 */

