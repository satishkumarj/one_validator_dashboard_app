import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InformationScreen extends StatefulWidget {
  InformationScreen({this.title, this.url});
  final String url;
  final String title;

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  String url;
  String title;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (url == null) {
      url = "https://harmony.one";
    }
    title = widget.title;
    if (title == null) {
      title = 'Information';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
