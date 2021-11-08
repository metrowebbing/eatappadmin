import 'package:eatappadmin/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";

  void SignOutME() async {
    await _auth.signOut();
  }

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await _auth.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

  showMobilePhoneWidget(context) {
    return Container(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: TextField(
              controller: phoneController,
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
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 40,
                  child: Center(
                      child: Text(
                    'Получить код',
                    style: TextStyle(fontSize: 16),
                  ))),
            ),
            onPressed: () async {
              await _auth.verifyPhoneNumber(
                  phoneNumber: "+7${phoneController.text}",
                  verificationCompleted: (phoneAuthCredential) async {},
                  verificationFailed: (verificationFailed) {
                    print(verificationFailed);
                  },
                  codeSent: (verificationID, resendingToken) async {
                    setState(() {
                      currentState = LoginScreen.SHOW_OTP_FORM_WIDGET;
                      this.verificationID = verificationID;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationID) async {});
            },
          ),
          SizedBox(
            height: 16,
          ),
          Spacer()
        ],
      ),
    );
  }

  showOtpFormWidget(context) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            "Введите код из смс",
            style: TextStyle(
                fontSize: 20,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Проверочный код"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                AuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationID,
                        smsCode: otpController.text);
                signInWithPhoneAuthCred(phoneAuthCredential);
              },
              child: Container(
                  height: 40, child: Center(child: Text("Отправить")))),
          SizedBox(
            height: 16,
          ),
          Spacer()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: currentState == LoginScreen.SHOW_MOBILE_ENTER_WIDGET
          ? showMobilePhoneWidget(context)
          : showOtpFormWidget(context),
    );
  }
}
