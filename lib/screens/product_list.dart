import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class ProductList extends StatefulWidget {
  ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    getFields();
    checkDocOr();
    getRest();
    super.initState();
  }

  bool checkDoc = false;
  checkDocOr() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('order_count')
        .doc(user!.uid)
        .get();
    this.setState(() {
      checkDoc = ds.exists;
    });
  }

  var guid = 0;

  void getFields() async {
    FirebaseFirestore.instance
        .collection('order_count')
        .where('userid', isEqualTo: '${user!.uid}')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        guid = doc["count"];
        print(guid);
      });

      setState(() {});
    });
  }

  var vendRest = '';
  void getRest() async {
    FirebaseFirestore.instance
        .collection('orders')
        .where('user', isEqualTo: '${user!.uid}')
        .where('ordercount', isEqualTo: guid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        vendRest = doc["vendor"];
        print(vendRest);
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('guid'),
        actions: [
          IconButton(
              onPressed: () {
                checkDocOr();
              },
              icon: Icon(Icons.replay))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('category')
            .where('idrest', isEqualTo: 'mack')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text('Загрузка...'));
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String docId = snapshot.data!.docs[index].get('id');
                var sum = snapshot.data!.docs[index].get('por');

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(docId),
                          trailing:

                              // check

                              checkDoc
                                  // если есть
                                  ? FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('order_items')
                                          .doc(docId +
                                              '_' +
                                              '$guid'.toString() +
                                              '_' +
                                              user!.uid)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return SizedBox();
                                        }

                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return RaisedButton(
                                              color: Colors.green,
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () async {
                                                showModalBottomSheet<void>(
                                                  isScrollControlled: false,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20.0))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: <Widget>[
                                                              const Text(
                                                                  'Modal BottomSheet'),
                                                              ElevatedButton(
                                                                  child: const Text(
                                                                      'Close BottomSheet'),
                                                                  onPressed:
                                                                      () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'order_items')
                                                                        .doc(docId +
                                                                            '_' +
                                                                            '$guid'.toString() +
                                                                            '_' +
                                                                            user!.uid)
                                                                        .set({
                                                                      'id':
                                                                          docId,
                                                                      'count':
                                                                          1,
                                                                    });
                                                                    getFields();
                                                                  }),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return RaisedButton(
                                              color: Colors.orange,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {});
                                        }

                                        return SizedBox();
                                      },
                                    )

                                  // Если нет
                                  : FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('order_items')
                                          .doc(docId +
                                              '_' +
                                              '$guid'.toString() +
                                              '_' +
                                              user!.uid)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return SizedBox();
                                        }

                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return RaisedButton(
                                              color: Colors.orange,
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('order_count')
                                                    .doc(user!.uid)
                                                    .set({
                                                  'userid': user!.uid,
                                                  'count': 1,
                                                });

                                                getFields();
                                                checkDocOr();

                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 200,
                                                      color: Colors.amber,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: <Widget>[
                                                            const Text(
                                                                'Modal BottomSheet'),
                                                            ElevatedButton(
                                                                child: const Text(
                                                                    'Close BottomSheet'),
                                                                onPressed:
                                                                    () async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'order_items')
                                                                      .doc(docId +
                                                                          '_' +
                                                                          '$guid'
                                                                              .toString() +
                                                                          '_' +
                                                                          user!
                                                                              .uid)
                                                                      .set({
                                                                    'id': docId,
                                                                    'count': 1,
                                                                  });
                                                                  getFields();
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          Map<String, dynamic> data =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return RaisedButton(
                                              color: Colors.orange,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              onPressed: () {});
                                        }

                                        return SizedBox();
                                      },
                                    ),
                          subtitle: Text(sum.toString()),
                        ),
                      ),
                    ));
              });
        },
      ),
    );
  }
}
