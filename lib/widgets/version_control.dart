import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


class VersionControl extends StatefulWidget {
  final String? appUrl;
  const VersionControl({Key? key, this.appUrl}) : super(key: key);

  @override
  State<VersionControl> createState() => _VersionControlState();
}

class _VersionControlState extends State<VersionControl> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/body_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xff2a166f),
                backgroundColor: const Color(0xfffdc106), // foreground
              ),
              onPressed: () {
                print('APP URL : ${widget.appUrl}');
                var url = Uri.parse(widget.appUrl!);
                _launchInWebViewOrVC(url);
              },
              child: const Text('App Update Available', style: TextStyle(fontSize: 18)),
            )
          ),
        ),
      ),
    );
  }

}

Future<void> _launchInWebViewOrVC(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}


