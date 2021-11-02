import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class DetailProduct extends StatefulWidget {
  final DocumentSnapshot prod;

  DetailProduct({required this.prod});

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  void initState() {
    super.initState();
    checkDocItems();
    getFields();
    getRest();
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
      });
      setState(() {});
    });
  }

  bool checkItems = false;
  checkDocItems() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('orders')
        .doc(user!.uid + '$guid')
        .collection('items')
        .doc(widget.prod.get('productId'))
        .get();
    this.setState(() {
      checkItems = ds.exists;
    });
  }

  String vendRest = '';
  void getRest() async {
    FirebaseFirestore.instance
        .collection('orders')
        .where('user', isEqualTo: '${user!.uid}')
        .where('status', isEqualTo: 'processing')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        vendRest = doc["vendor"];
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final pr = widget.prod;

    var imageUrl = '';

    pr.get('imgUrl') == null
        ? imageUrl =
            'https://firebasestorage.googleapis.com/v0/b/foodex-c0e31.appspot.com/o/system%2Fnoimage.jpg?alt=media&token=e69bad78-3383-4e0a-beb8-6646439e970e'
        : imageUrl = imageUrl = pr.get('imgUrl');

    String vendor = pr.get('vendorId');
    String prId = pr.get('productId');
    String name = pr.get('name');
    num price = pr.get('price');
    // String prId = pr.get('productId');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    height: 350,
                    imageUrl: '$imageUrl',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          )),
                      // height: 45,
                      child: ListTile(
                        title: Text(
                          name,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 4),
                                    blurRadius: 8)
                              ],
                              border: Border.all(
                                color: Colors.grey.shade50,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: Icon(
                            Icons.chevron_left,
                            size: 35,
                          ),
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(price.toString() + ' \u{20bd}',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                    // Text(' / порция',
                    //     style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black54))
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Описание',
                  style: TextStyle(fontSize: 24, color: Colors.black87),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    pr.get('subname') ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        offset: Offset(0, -3),
                        blurRadius: 12)
                  ],
                ),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Spacer(),
                        Container(
                          child: FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('order_count')
                                .doc(user!.uid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return SizedBox();
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                int orderCount = data['count'];
                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(user!.uid + '$orderCount')
                                      .collection('items')
                                      .doc(prId)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }

                                    if (snapshot.hasData &&
                                        !snapshot.data!.exists) {
                                      return InkWell(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 15, 20, 15),
                                              child: Text(
                                                'В корзину',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                            )),
                                        onTap: () {
                                          if (vendRest == '') {
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(user!.uid + '$orderCount')
                                                .set({
                                              'vendor': vendor,
                                              'user': user!.uid,
                                              'ordercount': orderCount,
                                              'status': 'processing',
                                              'itemsCount': 1
                                            });
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(user!.uid + '$orderCount')
                                                .collection('items')
                                                .doc(prId)
                                                .set({
                                              'count': 1,
                                              'productId': prId,
                                              'name': name,
                                              'price': price,
                                              'image': imageUrl
                                            });

                                            getFields();
                                          } else if (vendRest == vendor) {
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(user!.uid + '$orderCount')
                                                .collection('items')
                                                .doc(prId)
                                                .set({
                                              'count': 1,
                                              'productId': prId,
                                              'name': name,
                                              'price': price,
                                              'image': imageUrl
                                            });
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(user!.uid + '$orderCount')
                                                .update({
                                              'itemsCount':
                                                  FieldValue.increment(1)
                                            });
                                            getFields();
                                          } else if (vendRest != vendor &&
                                              vendRest != '') {
                                            showDialog<String>(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Внимание',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20),
                                                    ),
                                                    Text('В одном заказе могут быть товары только из одного ресторана.' +
                                                        '\n' +
                                                        'Очистить корзину?'),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors
                                                          .red, // background
                                                      onPrimary: Colors
                                                          .white, // foreground
                                                    ),
                                                    onPressed: () {
                                                      CollectionReference
                                                          items =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'orders')
                                                              .doc(user!.uid +
                                                                  '$orderCount')
                                                              .collection(
                                                                  'items');

                                                      Future<void>
                                                          batchDelete() {
                                                        WriteBatch batch =
                                                            FirebaseFirestore
                                                                .instance
                                                                .batch();

                                                        return items.get().then(
                                                            (querySnapshot) {
                                                          querySnapshot.docs
                                                              .forEach(
                                                                  (document) {
                                                            batch.delete(
                                                                document
                                                                    .reference);
                                                          });

                                                          return batch.commit();
                                                        });
                                                      }

                                                      batchDelete();

                                                      FirebaseFirestore.instance
                                                          .collection('orders')
                                                          .doc(user!.uid +
                                                              '$orderCount')
                                                          .update({
                                                        'vendor': vendor,
                                                        'itemsCount': 0
                                                      });

                                                      getRest();
                                                      Navigator.pop(context);
                                                      //
                                                      showDialog<String>(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            WillPopScope(
                                                          onWillPop: () async {
                                                            return false;
                                                          },
                                                          child: AlertDialog(
                                                            content: Text(
                                                              'Корзина очищена, товар добавлен.',
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                            actions: <Widget>[
                                                              OutlinedButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'orders')
                                                                      .doc(user!
                                                                              .uid +
                                                                          '$orderCount')
                                                                      .collection(
                                                                          'items')
                                                                      .doc(prId)
                                                                      .set({
                                                                    'count': 1,
                                                                    'productId':
                                                                        prId,
                                                                    'name':
                                                                        name,
                                                                    'price':
                                                                        price,
                                                                    'image':
                                                                        imageUrl
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                  getFields();
                                                                },
                                                                child:
                                                                    Text('Ок'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                      //
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text('Очистить'),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .green, // background
                                                        onPrimary: Colors
                                                            .white, // foreground
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Нет'),
                                                      ))
                                                ],
                                              ),
                                            );

                                            // перезаписать вендора и очистить корзину
                                            print('3');
                                          }
                                        },
                                      );
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> data = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Text(
                                                'Количество можно\nуказать  в корзине'),
                                          ),
                                          // Spacer(),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow[600],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 15, 20, 15),
                                                child: Text(
                                                  'В корзине',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ],
                                      );
                                    }

                                    return CircularProgressIndicator();
                                  },
                                );
                              }

                              return Center(child: Text("loading"));
                            },
                          )
                          //
                          ,

                          //

                          //
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
