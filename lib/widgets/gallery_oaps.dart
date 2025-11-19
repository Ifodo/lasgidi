import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lasgidi/models/gallery_model.dart';
import 'package:lasgidi/services/webservices.dart';
import 'package:lasgidi/widgets/gallery_oap_details.dart';
import 'package:loading_gifs/loading_gifs.dart';

class GalleryOAP extends StatefulWidget {
  const GalleryOAP({Key? key}) : super(key: key);

  @override
  _GalleryOAPState createState() => _GalleryOAPState();
}

class _GalleryOAPState extends State<GalleryOAP> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var station = 'Lagos';

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: FutureBuilder<List>(
            future: getGalleries(station),
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              }
              
              // Error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Color(0xff2a166f)),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to load OAPs',
                        style: TextStyle(fontSize: 18, color: Color(0xff2a166f), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your connection',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfffdc106),
                        ),
                        child: const Text('Retry', style: TextStyle(color: Color(0xff2a166f))),
                      ),
                    ],
                  ),
                );
              }
              
              // Empty state
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildPlaceholderGrid(screenWidth);
              }
              
              // Success state
              return GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    WelcomeGallery myImgFile = snapshot.data![index];
                    var imgUrl = 'https://servoserver.com.ng/lasgidifm/uploads/${myImgFile.oapPicture}';
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: const Color(0x40fdc106), width: 1.0),
                              image: DecorationImage(
                                image: NetworkImage(imgUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: screenWidth * 0.5,
                                  decoration: BoxDecoration(
                                    color: const Color(0x60ffffff),
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(color: const Color(0x60ffffff), width: 1.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${myImgFile.oapPersonalityName}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Color(0xff2a166f),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Gotham XLight'
                                        )),
                                  ),
                                )
                            ),
                          ),

                      ),
                      onTap: () {
                        _viewProfile(myImgFile);
                      },
                    );
                  });
            },
          ),
        ),
      ],
    );
  }
  Widget _buildPlaceholderGrid(double screenWidth) {
    return GridView.builder(
      itemCount: 9, // Show 9 placeholder items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: const Color(0x40fdc106), width: 1.0),
              color: Colors.grey[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 40, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _viewProfile(WelcomeGallery myData){
    //Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GalleryOapDetails(
              image: myData.oapPicture,
              fullName: myData.oapFullName,
              personalityName: myData.oapPersonalityName,
              profile: myData.profile,
            )
        )
    );
  }
}
