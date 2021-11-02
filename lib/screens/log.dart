import 'dart:ui';

import 'package:eatappadmin/screens/home.dart';
import 'package:eatappadmin/screens/politika.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text('Неверный код из СМС')));
    }
  }

  getMobileFormWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Spacer(),
          Center(
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/login/phone.png")),
                  ))),
          SizedBox(height: 20),
          Text(
            "Вход по номеру телефона",
            style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: phoneController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Номер телефона',
              fillColor: Colors.transparent,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefix: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text('+7',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return Politika();
              }),
            ),
            child: Container(
                child: RichText(
              text: TextSpan(
                text: 'Нажимая ',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Получить код',
                      style: TextStyle(color: Colors.red)),
                  TextSpan(text: ' вы соглашаетесь с '),
                  TextSpan(
                      text: 'условиями использования сервиса',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      )),
                  TextSpan(text: '.'),
                ],
              ),
            )),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                phoneNumber: "+7${phoneController.text}",
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  //signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  // _scaffoldKey.currentState!.showSnackBar(
                  //     SnackBar(content: Text(verificationFailed.message)));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text("Получить код"),
          ),
          Spacer(),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Spacer(),
          Center(
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/login/otp.png")),
                  ))),
          SizedBox(height: 20),
          Text(
            "Введите код из СМС",
            style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: otpController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
            ],
            maxLength: 6,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Код из смс',
              fillColor: Colors.transparent,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);

              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text("Отправить"),
          ),
          Spacer(),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
