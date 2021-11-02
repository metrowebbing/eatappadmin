import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

var user = FirebaseAuth.instance.currentUser;

class Akcii extends StatefulWidget {
  Akcii({Key? key}) : super(key: key);

  @override
  _AkciiState createState() => _AkciiState();
}

class _AkciiState extends State<Akcii> {
  @override
  void initState() {
    getFields();

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      height: 132,
      margin: EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('akcii').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              String imageUrl = snapshot.data!.docs[index].get('img');
              String akciiName = snapshot.data!.docs[index].get('name');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 190,
                  child: Column(
                    children: [
                      Container(
                        child: Stack(children: [
                          CachedNetworkImage(
                            height: 116,
                            imageUrl: '$imageUrl',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.white.withOpacity(0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(akciiName + ' ' + userCity),
                                )),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
