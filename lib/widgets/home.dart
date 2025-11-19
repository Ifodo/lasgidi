import 'package:flutter/material.dart';
import 'package:lasgidi/widgets/constants.dart';
import 'package:lasgidi/widgets/contact.dart';
import 'package:lasgidi/widgets/gallery_oaps.dart';
import 'package:lasgidi/widgets/home_page.dart';
import 'package:lasgidi/widgets/news.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      //initialIndex: dow - 1,
      child: Scaffold(
        backgroundColor: const Color(0xffe9e9e9),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Column(
            children: [
              Center(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: TabBar(
                      labelColor: const Color(0xff2a166f),
                      unselectedLabelColor: const Color(0xFF9F9F9F),
                      unselectedLabelStyle: const TextStyle(fontSize: 14.0, color: Color(0xFF9F9F9F)),
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      indicatorColor: const Color(0xff2a166f),
                      labelStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF9F9F9F),
                        fontWeight: FontWeight.bold,
                      ).copyWith(fontSize: 18.0),
                      tabs: const [
                        Tab(text: "Home"),
                        Tab(text: "News"),
                        Tab(text: "OAPs"),
                        Tab(text: "Contact")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/body_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const TabBarView(
            children: [
              HomePage(),
              NewsPage(),
              GalleryOAP(),
              Contact()

            ],
          ),
        ),
      ),
    );
  }
}
