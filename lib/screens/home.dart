import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/widgets/citycheck.dart';
import 'package:eatappadmin/widgets/menubar.dart';
import 'package:eatappadmin/widgets/restolist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String token;

  @override
  void initState() {
    getFields();
    super.initState();

    getToken();
  }

  String userCity = '';
  void getFields() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: '${user!.uid}')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        userCity = doc["city"];
      });
      setState(() {});
    });
  }

  void SignOutME() async {
    await FirebaseAuth.instance.signOut();
  }

  createOrderCount() {
    FirebaseFirestore.instance
        .collection('order_count')
        .doc(user!.uid)
        .set({'user': user!.uid, 'count': 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return CityCheck();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Akcii(),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        // decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text('Рестораны и кафе',
                              style: TextStyle(
                                  fontSize: 28, color: Colors.black87)),
                        ),
                      ),
                      RestoList(),
                    ],
                  ),
                ),
              );
            }

            return Center(
                child: CircularProgressIndicator(color: Colors.grey[300]));
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: MenuBar(params: 0),
    );
  }

  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    setState(() {
      token = token;
    });
    final FirebaseFirestore _database = FirebaseFirestore.instance;
    _database.collection('users').doc(user!.uid).update({"token": token});
  }
}
