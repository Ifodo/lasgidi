import 'package:flutter/material.dart';
import 'package:loading_gifs/loading_gifs.dart';

class GalleryOapDetails extends StatelessWidget {
  final String? image;
  final String? fullName;
  final String? personalityName;
  final String? profile;

  const GalleryOapDetails({
    Key? key,
    @required this.image,
    @required this.fullName,
    @required this.personalityName,
    @required this.profile
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var oap_picture = 'https://servoserver.com.ng/lasgidifm/uploads/$image';
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/header_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff2a166f)),
          onPressed: (){
            //Navigator.of(context, rootNavigator: true).pop(context);
            Navigator.pop(context);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => OAPsSelect()));
          }
          ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 60),
              child: Center(
                  child: Text('OAP Profile', style: TextStyle(
                      color: Color(0xff2a166f))
                  )
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Text(fullName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff2a166f),
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage.assetNetwork(
                  height: 250.0,
                  width: screenWidth,
                  placeholder: cupertinoActivityIndicator,
                  image: oap_picture,
                  placeholderScale: 5,
                  fit: BoxFit.cover,
                ),
                //Image.asset(circularProgressIndicator, scale: 10),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Text(fullName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff2a166f),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight + 400,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Text(profile!,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Color(0xff2a166f),
                                  fontSize: 17.0,
                                ),
                              ),
                          ),

                      ),

                      /*Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: SingleChildScrollView(
                            child: Text(profile,
                              softWrap: true,
                              style: TextStyle(
                                color: Color(0xff2a166f),
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),*/

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: const [
                            /*Text(
                              TimeAgo.getTimeAgo(DateTime.parse(date)),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],

                  ),
                ),


          ],
        ),
      ),
    );
  }
}
