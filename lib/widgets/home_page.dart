import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lasgidi/models/noa_model.dart';
import 'package:lasgidi/services/webservices.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  stopAudio() {
    final player = AudioPlayer();
    player.pause();
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<NowAndNext> _data;

  @override
  void initState() {
    super.initState();
    _data = nowOnAirData();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
            // Now On Air Image Section
          Container(
            height: screenHeight * 0.35,
            width: screenWidth,
            color: Colors.transparent,
              child: FutureBuilder<NowAndNext>(
              future: _data,
              builder: (BuildContext context, AsyncSnapshot<NowAndNext> snapshot) {
                if (snapshot.hasData && snapshot.data?.nowOnAir != null) {
                  final nowOnAir = snapshot.data!.nowOnAir!;
                  String? imageUrl = nowOnAir.image;
                  
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: FadeInImage.assetNetwork(
                      height: screenHeight * 0.35,
                      width: screenWidth,
                          placeholder: cupertinoActivityIndicator,
                              image: imageUrl,
                          placeholderScale: 1,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/logoMain3.png', fit: BoxFit.contain);
              },
            ),
          ),
                          // Gradient overlay at bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(12.0),
              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfffdc106),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Text(
                                      'LIVE',
                                    style: TextStyle(
                                        color: Color(0xff2a166f),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      nowOnAir.programName ?? 'Now Playing',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                          ),
                        );
                      }
                }
                
                // Default placeholder
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CupertinoActivityIndicator())
                        : Image.asset('assets/logoMain3.png', fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15.0),
          
          // Now On Air Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FutureBuilder<NowAndNext>(
              future: _data,
              builder: (BuildContext context, AsyncSnapshot<NowAndNext> snapshot) {
                if (snapshot.hasData && snapshot.data?.nowOnAir != null) {
                  final nowOnAir = snapshot.data!.nowOnAir!;
                  
                  var programName = nowOnAir.programName ?? 'No Program';
                  var presenters = nowOnAir.oaps?.join(', ') ?? 'DJ';
                  var durationStart = nowOnAir.duration?.start ?? '--:--';
                  var durationEnd = nowOnAir.duration?.end ?? '--:--';

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff2a166f), Color(0xff4a2d8f)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff2a166f).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: const Color(0xfffdc106),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: const Text(
                                'NOW ON AIR',
                                style: TextStyle(
                                  color: Color(0xff2a166f),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.radio, color: Color(0xfffdc106), size: 24),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          programName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xfffdc106), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                presenters,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xfffdc106), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '$durationStart - $durationEnd',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                  ),
                ],
              ),
                  );
                }
                
                // Loading or empty state
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const CupertinoActivityIndicator()
                        : const Text(
                            'No program currently airing',
                            style: TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                  ),
                );
              },
            ),
          ),
          
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: const Text(
                'Your #1 Owambe Station',
                textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xffec1d23),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
        ],
        ),
      ),
    );
  }
}
