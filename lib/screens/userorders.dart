import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/widgets/menubar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var user = FirebaseAuth.instance.currentUser;

class UserOrders extends StatefulWidget {
  UserOrders({Key? key}) : super(key: key);

  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  @override
  void initState() {
    getFields();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: InkWell(
        //   onTap: () => Navigator.pop(context),
        //   child: Container(
        //     width: 40,
        //     height: 40,
        //     child: Icon(
        //       Icons.chevron_left,
        //       size: 30,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Мои заказы',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('ordercount', descending: true)
                .where('user', isEqualTo: user!.uid)
                .where('status',
                    whereIn: ['ordering', 'deliver', 'dostav', 'otmena'])
                // .where('comment', isNull: true)
                .limit(5)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = snapshot.data!.docs[index].get('name');
                  String phone = snapshot.data!.docs[index].get('phone');
                  num orderCount = snapshot.data!.docs[index].get('ordercount');
                  num total = snapshot.data!.docs[index].get('total');
                  num dost = snapshot.data!.docs[index].get('dost');
                  num sumOrder = snapshot.data!.docs[index].get('sumOrder');
                  String status = snapshot.data!.docs[index].get('status');
                  //adress
                  String street = snapshot.data!.docs[index].get('street');
                  String dom = snapshot.data!.docs[index].get('dom');
                  String podezd = snapshot.data!.docs[index].get('podezd');
                  String kvartira = snapshot.data!.docs[index].get('kvartira');
                  //

                  Timestamp date = snapshot.data!.docs[index].get('date');
                  DateTime dateOrder = date.toDate();

                  String dateOrderus =
                      DateFormat('dd.MM.yyyy – kk:mm').format(dateOrder);

                  var phoneSimbols = phone.substring(phone.length - 4);

                  String statusS = '';
                  var stColor = Colors.green;

                  if (status == 'ordering') {
                    statusS = 'В обработке';
                    stColor = Colors.green;
                  } else if (status == 'deliver') {
                    statusS = 'Отправлен';
                    stColor = Colors.purple;
                  } else if (status == 'dostav') {
                    statusS = 'Доставлен';
                    stColor = Colors.blue;
                  } else if (status == 'otmena') {
                    statusS = 'Заказ отменен';
                    stColor = Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Заказ №  $phoneSimbols—$orderCount',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        dateOrderus,
                                        style:
                                            TextStyle(color: Colors.blue[800]),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: stColor,
                                    ),
                                    child: Text(
                                      statusS,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(user!.uid + '$orderCount')
                                    .collection('items')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                        child: CircularProgressIndicator());
                                  return ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      String name = snapshot.data!.docs[index]
                                          .get('name');
                                      int itemsCount = snapshot
                                          .data!.docs[index]
                                          .get('count');
                                      String imageUrl = snapshot
                                          .data!.docs[index]
                                          .get('image');
                                      int price = snapshot.data!.docs[index]
                                          .get('price');

                                      return Card(
                                        elevation: 0.4,
                                        child: ListTile(
                                          leading: SizedBox(
                                              height: 120.0,
                                              width:
                                                  50, // fixed width and height
                                              child: CachedNetworkImage(
                                                height: 100,
                                                imageUrl: '$imageUrl',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Center(
                                                        child:
                                                            Icon(Icons.error)),
                                              )),
                                          title: Text(name),
                                          trailing:
                                              Text('$itemsCount  x  $price'),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Адрес: ул. $street, д. $dom, п.$podezd, кв.$kvartira'),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Стоимость заказа:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '$total',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Стоимость доставки:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '$dost',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Общая стоимость:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$sumOrder \u{20bd}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
      extendBody: true,
      bottomNavigationBar: MenuBar(params: 2),
    );
  }
}
