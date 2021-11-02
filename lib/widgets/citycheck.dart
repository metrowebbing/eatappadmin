import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class CityCheck extends StatefulWidget {
  const CityCheck({Key? key}) : super(key: key);

  @override
  State<CityCheck> createState() => _CityCheckState();
}

class _CityCheckState extends State<CityCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Выберите ваш город из списка',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('city')
                        .orderBy('name')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                            child: Container(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()));
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          String name = snapshot.data!.docs[index].get('name');
                          String id = snapshot.data!.docs[index].get('id');
                          return Container(
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 2),
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      size: 25,
                                      color: Colors.green,
                                    ),
                                    trailing: FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('order_count')
                                          .doc(user!.uid)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return ElevatedButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('order_count')
                                                  .doc(user!.uid)
                                                  .set({
                                                'user': user!.uid,
                                                'count': 1,
                                              });
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user!.uid)
                                                  .set({
                                                'city': id,
                                                'user': user!.uid
                                              });

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return Home();
                                                }),
                                              );
                                            },
                                            child: Text('Выбрать'),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return Home();
                                                }),
                                              );
                                            },
                                            child: Text('Выбрать'),
                                          );
                                        }

                                        return Text("loading");
                                      },
                                    ),
                                    title: Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
