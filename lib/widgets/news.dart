import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:lasgidi/widgets/news_article.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:lasgidi/models/noa_model.dart';
import 'package:lasgidi/services/webservices.dart';
import 'package:get_time_ago/get_time_ago.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5.0),
              child: Container(
                width: screenWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border:
                        Border.all(color: const Color(0xFFEAEAEA), width: 1.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: screenWidth,
                      child: FutureBuilder<List>(
                        future: fetchWpPost(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  Map wpPost = snapshot.data![index];
                                  var featuredImg = wpPost['featured_media'];
                                  if (featuredImg != 0) {
                                    var imageUrl = wpPost['_embedded']
                                        ['wp:featuredmedia'][0]['source_url'];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: FadeInImage.assetNetwork(
                                        height: 200,
                                        width: screenWidth,
                                        placeholder: cupertinoActivityIndicator,
                                        image: imageUrl,
                                        placeholderScale: 1,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    var imageUrl =
                                        'https://lasgidifm.com/wp-content/uploads/2019/10/lasgidi_logo.png';
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: FadeInImage.assetNetwork(
                                        height: 200,
                                        width: screenWidth,
                                        placeholder: cupertinoActivityIndicator,
                                        image: imageUrl,
                                        placeholderScale: 1,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                });
                          }
                          return const Center(
                              child: CupertinoActivityIndicator());
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List>(
                      future: fetchWpPost(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          Map wpPost = snapshot.data![0];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                parse(wpPost['title']['rendered'])
                                    .documentElement!
                                    .text,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    color: Color(0xff2a166f),
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 3.0),
                              Text(
                                GetTimeAgo.parse(
                                    DateTime.parse(wpPost['date'])),
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xffff0002),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth,
              padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 10.0, bottom: 10.0),
              child: FutureBuilder<List>(
                future: fetchWpPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Map wpPost = snapshot.data![index];
                        //episode_featured_image
                        //var imageUrl = wpPost['_embedded']['wp:featuredmedia'][0]['source_url'] ?? null;
                        //var featuredImg = wpPost['_embedded'] ?? 0;
                        var featuredImg = wpPost['featured_media'];
                        if (featuredImg != null || featuredImg != 0) {
                          var imageUrl = wpPost['_embedded']['wp:featuredmedia']
                              [0]['source_url'];

                          return imageUrl != null
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsArticle(
                                                  url: wpPost['link'],
                                                  title: wpPost['title']
                                                      ['rendered'],
                                                  date: wpPost['date'],
                                                  content: wpPost['content']
                                                      ['rendered'],
                                                  imageUrl: imageUrl,
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5.0, top: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Container(
                                            width: screenWidth - 25,
                                            height: 90.0,
                                            //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFFEAEAEA),
                                                    width: 1.0)),
                                            child: Row(
                                              children: [
                                                const SizedBox(height: 10.0),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            imageUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 5.0),
                                                          SizedBox(
                                                            width: screenWidth /
                                                                    1.8 -
                                                                10,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  parse(wpPost[
                                                                              'title']
                                                                          [
                                                                          'rendered'])
                                                                      .documentElement!
                                                                      .text,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 4,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Color(
                                                                          0xff2a166f)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            GetTimeAgo.parse(
                                                                DateTime.parse(
                                                                    wpPost[
                                                                        'date'])),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              height: 10.0)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewsArticle(
                                                  url: wpPost['link'],
                                                  title: wpPost['title']['rendered'],
                                                  date: wpPost['date'],
                                                  content: wpPost['content']['rendered'],
                                                  imageUrl: 'https://lasgidifm.com/wp-content/uploads/2019/10/lasgidi_logo.png',
                                                )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5.0, top: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Container(
                                            width: screenWidth - 25,
                                            height: 90.0,
                                            //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                border: Border.all(
                                                    color:
                                                        const Color(0xFFEAEAEA),
                                                    width: 1.0)),
                                            child: Row(
                                              children: [
                                                const SizedBox(height: 10.0),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      image: const DecorationImage(
                                                        image: NetworkImage(
                                                            'https://lasgidifm.com/wp-content/uploads/2019/10/lasgidi_logo.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 5.0),
                                                          SizedBox(
                                                            width: screenWidth /
                                                                    1.8 -
                                                                10,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  parse(wpPost[
                                                                              'title']
                                                                          [
                                                                          'rendered'])
                                                                      .documentElement!
                                                                      .text,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 4,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Color(
                                                                          0xff2a166f)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            GetTimeAgo.parse(
                                                                DateTime.parse(
                                                                    wpPost[
                                                                        'date'])),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11.0,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              height: 10.0)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        } else {
                          var imageUrl =
                              'https://lasgidifm.com/wp-content/uploads/2019/10/lasgidi_logo.png';
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsArticle(
                                            url: wpPost['link'],
                                            title: wpPost['title']['rendered'],
                                            date: wpPost['date'],
                                            content: wpPost['content']
                                                ['rendered'],
                                            imageUrl: imageUrl,
                                          )));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5.0, top: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Container(
                                      width: screenWidth - 25,
                                      height: 100.0,
                                      //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: const Color(0xFFEAEAEA),
                                              width: 1.0)),
                                      child: Row(
                                        children: [
                                          const SizedBox(height: 10.0),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 5.0),
                                                    SizedBox(
                                                      width: screenWidth / 1.8 -
                                                          10,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            parse(wpPost[
                                                                        'title']
                                                                    [
                                                                    'rendered'])
                                                                .documentElement!
                                                                .text,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 4,
                                                            style: const TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff2a166f)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      GetTimeAgo.parse(
                                                          DateTime.parse(
                                                              wpPost['date'])),
                                                      style: const TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.red),
                                                    ),
                                                    const SizedBox(height: 10.0)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                  return const Center(child: CupertinoActivityIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}*/
