import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class UpdateCity extends StatelessWidget {
  const UpdateCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Expanded(
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
                            String name =
                                snapshot.data!.docs[index].get('name');
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
                                      title: Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .update({'city': id});
                                            Navigator.pop(context);
                                          },
                                          child: Text('Выбрать')),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
