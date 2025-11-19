import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lasgidi/widgets/contact.dart';
import 'package:lasgidi/widgets/home.dart';
import 'package:lasgidi/widgets/home_page.dart';
import 'package:lasgidi/widgets/version_control.dart';
import 'package:lasgidi/widgets/video_live_stream.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';
import 'package:lasgidi/services/webservices.dart';
import 'package:lasgidi/models/noa_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _player = AudioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  Future<NowAndNext>? _upNextData;

  bool lasCanUpdate = false;
  String? updateUrl;

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(AudioSource.uri(
          Uri.parse("https://azstream.elektranbroadcast.com/listen/lasgidi901/radio.mp3")));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    //ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
    checkVersion();
    _upNextData = nowOnAirData();
    // Refresh up next data every 30 seconds
    Future.delayed(Duration.zero, () {
      Stream.periodic(const Duration(seconds: 30)).listen((_) {
        if (mounted) {
          setState(() {
            _upNextData = nowOnAirData();
          });
        }
      });
    });
  }

  void checkVersion() async {
    try {
      final upgrader = Upgrader(
        durationUntilAlertAgain: const Duration(days: 1),
      );
      
      await upgrader.initialize();
      
      final appStoreVersion = upgrader.currentAppStoreVersion;
      final currentVersion = upgrader.currentInstalledVersion;
      
      if (appStoreVersion != null && currentVersion != null) {
        final isUpdateAvailable = upgrader.isUpdateAvailable();
        
            setState(() {
          lasCanUpdate = isUpdateAvailable;
          // Generate Play Store URL for the app
          updateUrl = 'https://play.google.com/store/apps/details?id=com.lasgidifm.lasgidi';
        });
      }
    } catch (e) {
      print('Error checking version: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: lasCanUpdate != true ? AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 100.0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/header_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 100,
                      height: 52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                              image: AssetImage('assets/logoMain3.png'))),
                    ),
                  ),
                ],
              ),
            ],
            title: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                child: SizedBox(
                  width: 70,
                  height: 60,
                  child: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Image.asset('assets/video_icon.png'),
                        onPressed: () {
                          //_radioPlayer.pause();
                          navigateToStream(context);
                        },
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text('Watch Live',
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              )
            ]),
          ): AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 100.0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/header_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 100,
                      height: 52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                              image: AssetImage('assets/logoMain3.png'))),
                    ),
                  ),
                ],
              ),
            ],
            title: Column(children: const [

            ]),
          ),
          body: lasCanUpdate == false ? const Home() : VersionControl(appUrl: updateUrl),
          bottomNavigationBar: BottomAppBar(
              child: lasCanUpdate != true
                  ? Container(
                      height: 100.0,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/header_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                            // Up Next Info
                            Expanded(
                              child: _upNextData == null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: const Center(
                                        child: CupertinoActivityIndicator(color: Colors.white60),
                                      ),
                                    )
                                  : FutureBuilder<NowAndNext>(
                                      future: _upNextData,
                                      builder: (BuildContext context, AsyncSnapshot<NowAndNext> snapshot) {
                                        if (snapshot.hasData && snapshot.data?.upNext != null) {
                                          final upNext = snapshot.data!.upNext!;
                                          var programName = upNext.programName ?? 'No Program';
                                          var durationStart = upNext.duration?.start ?? '--:--';

                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: const Color(0xfffdc106).withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xfffdc106),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      child: const Text(
                                                        'UP NEXT',
                                                        style: TextStyle(
                                                          color: Color(0xff2a166f),
                                                          fontSize: 9.0,
                                                          fontWeight: FontWeight.w900,
                                                          letterSpacing: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6.0),
                                                    const Icon(
                                                      Icons.access_time_rounded,
                                                      color: Color(0xfffdc106),
                                                      size: 12,
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    Text(
                                                      durationStart,
                                                      style: const TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4.0),
                                                Text(
                                                  programName,
                                                  style: const TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        // No up next program
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'No upcoming program',
                                              style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white60,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(width: 12.0),
                            // Play/Pause Button
                                StreamBuilder<PlayerState>(
                                  stream: _player.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                final processingState = playerState?.processingState;
                                    final playing = playerState?.playing;

                                // Loading/Buffering State
                                if (processingState == ProcessingState.loading ||
                                    processingState == ProcessingState.buffering) {
                                      return Container(
                                    width: 56.0,
                                    height: 56.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xfffdc106).withOpacity(0.2),
                                          const Color(0xfffdc106).withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                          color: Color(0xfffdc106),
                                        strokeWidth: 3.0,
                                      ),
                                    ),
                                  );
                                } 
                                // Play State
                                else if (playing != true) {
                                  return GestureDetector(
                                    onTap: _player.play,
                                    child: Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xfffdc106),
                                            Color(0xffffdb4d),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xfffdc106).withOpacity(0.5),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 32.0,
                                        color: Color(0xff2a166f),
                                      ),
                                    ),
                                  );
                                } 
                                // Pause State
                                else if (processingState != ProcessingState.completed) {
                                  return GestureDetector(
                                    onTap: _player.pause,
                                    child: Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                                  Color(0xfffdc106),
                                            Color(0xffffdb4d),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xfffdc106).withOpacity(0.5),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.pause_rounded,
                                        size: 32.0,
                                        color: Color(0xff2a166f),
                                      ),
                                    ),
                                  );
                                } 
                                // Replay State
                                else {
                                  return GestureDetector(
                                    onTap: () => _player.seek(Duration.zero),
                                    child: Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xfffdc106),
                                            Color(0xffffdb4d),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xfffdc106).withOpacity(0.5),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.replay_rounded,
                                        size: 32.0,
                                        color: Color(0xff2a166f),
                                      ),
                                    ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                      /*child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Icon(Icons.play_arrow),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                        backgroundColor: MaterialStateProperty.all(const Color(0xfffdc106)), // <-- Button color
                        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.pressed)) return const Color(0xffec1d23); // <-- Splash color
                        }),
                      ),
                    ),
                  )
                ],
              )*/
                      )
                  : Container(
                      height: 100,
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/header_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
        ));
  }
}

stopAudioStream() {
  const HomePage().stopAudio();
}

navigateToStream(context) {
  stopAudioStream();
  Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => VideoLiveStream())
      MaterialPageRoute(builder: (context) => const VideoLiveStream()));
}
