import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/detailpage_prod.dart';
import 'package:eatappadmin/widgets/menubar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var categoryId;
  var selectedIndex = '';

  Widget _tabs() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .where('vendorId', isEqualTo: widget.post.get('vendorId'))
          .orderBy('por', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: new LinearProgressIndicator());
        return Container(
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = document['title'];
                    categoryId = document['categoryId'];
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        color: selectedIndex == document['title']
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        boxShadow: selectedIndex == document['title']
                            ? [
                                BoxShadow(
                                    color: Theme.of(context).primaryColor,
                                    blurRadius: 1.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 1))
                              ]
                            : null,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text(
                        document['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: selectedIndex == document['title']
                                ? Colors.white
                                : Colors.black),
                      ),
                    )),
              );
            }).toList(),
          ),
        );
      },
    );
  }

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
      });
      setState(() {});
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

  navigateToDetail(DocumentSnapshot prod) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailProduct(
                  prod: prod,
                )));
  }

  @override
  Widget build(BuildContext context) {
    String namerest = widget.post.get('name');
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            child: Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black87,
            ),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          namerest,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(
                          'Примерное время доставки из "' + namerest + '"'),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('Понятно'),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.delivery_dining,
                              size: 16,
                              color: Colors.deepOrange,
                            ),
                          ),
                          TextSpan(
                              text: ' от ' +
                                  widget.post.get('dost').toString() +
                                  '\u{20bd}~' +
                                  widget.post.get('deltime') +
                                  ' мин',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(right: 10),
                  //   padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey[200],
                  //       borderRadius: BorderRadius.circular(30)),
                  //   child: RichText(
                  //     text: TextSpan(
                  //       children: [
                  //         WidgetSpan(
                  //           child: Icon(
                  //             Icons.access_time_outlined,
                  //             size: 16,
                  //             color: Colors.black87,
                  //           ),
                  //         ),
                  //         widget.post.get('deltime') != null
                  //             ? TextSpan(
                  //                 text:
                  //                     '~' + widget.post.get('deltime') + ' мин',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.black87))
                  //             : TextSpan(
                  //                 text: '~50 мин',
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.black87)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ),
                InkWell(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text(
                          'Минимальная стоимость заказа из "' + namerest + '"'),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('Понятно'),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0),
                    padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                        widget.post.get('minprice') != null
                            ? TextSpan(
                                text: ' от ' +
                                    widget.post.get('minprice').toString() +
                                    ' \u{20bd}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))
                            : TextSpan(
                                text: ' от 100 \u{20bd}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                      ]),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: widget.post.get('info') != null
                          ? Text('Информация о продавце: ' +
                              widget.post.get('info') +
                              '')
                          : Text('Информация о продавце не заполнена'),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: Text('Понятно'),
                        ),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0),
                    padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
            height: 40,
            child: _tabs(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('name', descending: false)
                  .where('vendorId', isEqualTo: widget.post.get('vendorId'))
                  .where('tab', isEqualTo: categoryId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: new CircularProgressIndicator());
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String name = snapshot.data!.docs[index].get('name');
                      num price = snapshot.data!.docs[index].get('price');

                      var image = '';

                      snapshot.data!.docs[index].get('imgUrl') == null
                          ? image =
                              'https://firebasestorage.googleapis.com/v0/b/foodex-c0e31.appspot.com/o/system%2Fnoimage.jpg?alt=media&token=e69bad78-3383-4e0a-beb8-6646439e970e'
                          : image = snapshot.data!.docs[index].get('imgUrl');

                      return InkWell(
                        onTap: () =>
                            navigateToDetail(snapshot.data!.docs[index]),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 30,
                                    child: CachedNetworkImage(
                                        imageUrl: image,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Icon(Icons
                                                    .image_not_supported))),
                                  ),
                                  Expanded(
                                    flex: 55,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 8, 8, 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 40,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Text(
                                                            price.toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      WidgetSpan(
                                                        child: Text(' \u{20bd}',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20)),
                                                      ),
                                                      // WidgetSpan(
                                                      //   child: Text('/порция',
                                                      //       style: TextStyle(
                                                      //           color: Colors
                                                      //               .black45,
                                                      //           fontSize: 14)),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'В корзину',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: MenuBar(params: 0),
    );
  }
}
