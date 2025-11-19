import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:html/parser.dart';
import 'package:loading_gifs/loading_gifs.dart';

class NewsArticle extends StatelessWidget {
  final String? title;
  final String? date;
  final String? content;
  final String? imageUrl;
  final String? url;

  const NewsArticle({
    Key? key,
    @required this.title,
    @required this.date,
    @required this.content,
    @required this.imageUrl,
    @required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/body_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
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
            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff)),
            onPressed: (){
              Navigator.pop(context, false);
            },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 60),
                child: Center(
                    child: Text('News Article', style: TextStyle(
                        color: Color(0xffffffff))
                    )
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Text(
                parse(title.toString())
                    .documentElement!
                    .text,
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
                  height: 300.0,
                  width: screenWidth,
                  placeholder: cupertinoActivityIndicator,
                  image: imageUrl!,
                  placeholderScale: 5,
                  fit: BoxFit.cover,
                ),
                //Image.asset(circularProgressIndicator, scale: 10),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Text(
                parse(title.toString())
                    .documentElement!
                    .text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff2a166f),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Text(
                              parse(content.toString())
                                  .documentElement!
                                  .text,
                              softWrap: true,
                              style: const TextStyle(
                                color: Color(0xff2a166f),
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                GetTimeAgo.parse(DateTime.parse(date!)),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  /*_shareContent(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share('Text',
        subject: 'subject',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }*/
}



