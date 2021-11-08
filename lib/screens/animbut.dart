import 'dart:async';

import 'package:flutter/material.dart';

bool onPressedValue = true;

class AnimBut extends StatefulWidget {
  AnimBut({Key? key}) : super(key: key);

  @override
  _AnimButState createState() => _AnimButState();
}

class _AnimButState extends State<AnimBut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: ElevatedButton(
              child: Text('OTP'),
              onPressed: onPressedValue == true
                  ? () {
                      setState(() {
                        onPressedValue = false;
                      });
                      Timer(Duration(seconds: 1), () {
                        setState(() {
                          onPressedValue = true;
                        });
                      });
                    }
                  : null)),
    ));
  }
}
