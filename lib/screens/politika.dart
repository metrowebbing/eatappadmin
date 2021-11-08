import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Politika extends StatefulWidget {
  @override
  PolitikaState createState() => PolitikaState();
}

class PolitikaState extends State<Politika> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            child: Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Политика и условия',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              WebView(
                // initialUrl:
                //     'https://firebasestorage.googleapis.com/v0/b/foodex-c0e31.appspot.com/o/system%2Fpolitika%2Fpolitika.html?alt=media&token=b95c79ee-f924-4d81-916c-83086c071a76',
                initialUrl: 'https://vezedu.ru/pol/index.html',
                // initialUrl: 'ya.ru',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.grey[300]))
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }
}
