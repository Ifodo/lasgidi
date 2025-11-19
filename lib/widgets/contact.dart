import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(
        '<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3964.7037464850055!2d3.4406084999999997!3d6.432089100000001!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x103bf5003488f0cf%3A0x23390970f62f8077!2sAmazing%20Grac%20Palaza!5e0!3m2!1sen!2sus!4v1763491616508!5m2!1sen!2sus" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>',
      );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/body_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: screenWidth,
                  height: 200,
                  child: Center(
                    child: WebViewWidget(controller: _controller),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 48.0),
                        child: Text('Studio', style: TextStyle(fontSize: 18, color: Color(0xff2a166f), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.asset('assets/location.png', width: 40, height: 40),
                          ),
                        ),
                        Expanded(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                            child: Text(
                              'Amazing Grace Plaza.\nPlot 2E-4E Ligali Ayorinde St, Victoria Island, Lagos',
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 48.0),
                        child: Text('Telephone', style: TextStyle(fontSize: 18, color: Color(0xff2a166f), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                          child: GestureDetector(
                            onTap: () => showAlertDialog(context),
                            child: Image.asset('assets/call.png', width: 40, height: 40),
                          ),
                        ),
                        Expanded(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                            child: Text(
                              '+234703 210 6379',
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 48.0),
                        child: Text('Email', style: TextStyle(fontSize: 18, color: Color(0xff2a166f), fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                          child: GestureDetector(
                            onTap: () => send(),
                            child: Image.asset('assets/mail.png', width: 40, height: 40),
                          ),
                        ),
                        Expanded(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                            child: Text(
                              'info@lasgidifm.com',
                              style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Advert Placements and Sponsorship'),
      onPressed: () {
        final phoneNumber = '+2347032106379';
        launchUrl(Uri.parse('tel:$phoneNumber'));
        Navigator.of(context).pop();
      },
    );
    /*Widget optionTwo = SimpleDialogOption(
      child: const Text('Other Information'),
      onPressed: () {
        print('Other Information');
        var _phoneNumber = '+2348120581249';
        launch('tel:$_phoneNumber');
        Navigator.of(context).pop();
      },
    );*/


    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Call Lasgidi 90.1 FM', style: TextStyle(fontWeight: FontWeight.bold)),
      children: <Widget>[
        optionOne,
        //optionTwo
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
  Future<void> send() async {
    final Email email = Email(
      body: 'Email body',
      subject: 'Email subject',
      recipients: ['info@lasgidifm.com'],
      /*cc: ['cc@example.com'],
      bcc: ['bcc@example.com'],*/
      //attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}