// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eatappadmin/screens/detailpage_prod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// var user = FirebaseAuth.instance.currentUser;

// class DetailPage extends StatefulWidget {
//   final DocumentSnapshot post;

//   DetailPage({required this.post});

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   var categoryId;
//   var selectedIndex = '';

//   Widget _tabs() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('categories')
//           .where('vendorId', isEqualTo: widget.post.get('vendorId'))
//           .orderBy('por', descending: false)
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData)
//           return Center(child: new LinearProgressIndicator());
//         return Container(
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             physics: BouncingScrollPhysics(),
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIndex = document['title'];
//                     categoryId = document['categoryId'];
//                   });
//                 },
//                 child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20.0),
//                     margin: EdgeInsets.symmetric(horizontal: 8.0),
//                     decoration: BoxDecoration(
//                         border:
//                             Border.all(color: Theme.of(context).primaryColor),
//                         color: selectedIndex == document['title']
//                             ? Theme.of(context).primaryColor
//                             : Colors.white,
//                         boxShadow: selectedIndex == document['title']
//                             ? [
//                                 BoxShadow(
//                                     color: Theme.of(context).primaryColor,
//                                     blurRadius: 1.0,
//                                     spreadRadius: 1.0,
//                                     offset: Offset(0, 1))
//                               ]
//                             : null,
//                         borderRadius: BorderRadius.circular(10.0)),
//                     child: Center(
//                       child: Text(
//                         document['title'],
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: selectedIndex == document['title']
//                                 ? Colors.white
//                                 : Colors.black),
//                       ),
//                     )),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     getFields();
//     checkDocOr();
//     getRest();
//     super.initState();
//   }

//   bool checkDoc = false;
//   checkDocOr() async {
//     DocumentSnapshot ds = await FirebaseFirestore.instance
//         .collection('order_count')
//         .doc(user!.uid)
//         .get();
//     this.setState(() {
//       checkDoc = ds.exists;
//     });
//   }

//   var guid = 0;
//   void getFields() async {
//     FirebaseFirestore.instance
//         .collection('order_count')
//         .where('userid', isEqualTo: '${user!.uid}')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         guid = doc["count"];
//       });
//       setState(() {});
//     });
//   }

//   String vendRest = '';
//   void getRest() async {
//     FirebaseFirestore.instance
//         .collection('orders')
//         .where('user', isEqualTo: '${user!.uid}')
//         .where('status', isEqualTo: 'processing')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         vendRest = doc["vendor"];
//       });
//       setState(() {});
//     });
//   }

//   navigateToDetail(DocumentSnapshot prod) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => DetailProduct(
//                   prod: prod,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.post.get('name')),
//           actions: [
//             ElevatedButton(
//                 onPressed: () {
//                   getFields();
//                   print('вендор- ' + vendRest);
//                 },
//                 child: Icon(Icons.add))
//           ],
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () => showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         content: Text('Примерное время доставки из "' +
//                             widget.post.get('name') +
//                             '"'),
//                         actions: <Widget>[
//                           OutlinedButton(
//                             onPressed: () => Navigator.pop(context, 'OK'),
//                             child: Text('Понятно'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     child: Container(
//                       margin: EdgeInsets.only(right: 10),
//                       padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(30)),
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             WidgetSpan(
//                               child: Icon(
//                                 Icons.access_time_outlined,
//                                 size: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             widget.post.get('deltime') != null
//                                 ? TextSpan(
//                                     text: '~' +
//                                         widget.post.get('deltime') +
//                                         ' мин',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87))
//                                 : TextSpan(
//                                     text: '~50 мин',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         content: Text('Минимальная стоимость заказа из "' +
//                             widget.post.get('name') +
//                             '"'),
//                         actions: <Widget>[
//                           OutlinedButton(
//                             onPressed: () => Navigator.pop(context, 'OK'),
//                             child: Text('Понятно'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     child: Container(
//                       margin: EdgeInsets.only(right: 15.0),
//                       padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(30)),
//                       child: RichText(
//                         text: TextSpan(children: [
//                           WidgetSpan(
//                             child: Icon(
//                               Icons.shopping_bag_outlined,
//                               size: 16,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           widget.post.get('minprice') != null
//                               ? TextSpan(
//                                   text: ' от ' +
//                                       widget.post.get('minprice').toString() +
//                                       ' \u{20bd}',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87))
//                               : TextSpan(
//                                   text: ' от 100 \u{20bd}',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87)),
//                         ]),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () => showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => AlertDialog(
//                         content: widget.post.get('info') != null
//                             ? Text('Информация о продавце: ' +
//                                 widget.post.get('info') +
//                                 '')
//                             : Text('Информация о продавце не заполнена'),
//                         actions: <Widget>[
//                           OutlinedButton(
//                             onPressed: () => Navigator.pop(context, 'OK'),
//                             child: Text('Понятно'),
//                           ),
//                         ],
//                       ),
//                     ),
//                     child: Container(
//                       margin: EdgeInsets.only(right: 15.0),
//                       padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(30)),
//                       child: RichText(
//                         text: TextSpan(children: [
//                           WidgetSpan(
//                             child: Icon(
//                               Icons.info_outline,
//                               size: 16,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
//               height: 40,
//               child: _tabs(),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('products')
//                     .orderBy('name', descending: false)
//                     .where('vendorId', isEqualTo: widget.post.get('vendorId'))
//                     .where('tab', isEqualTo: categoryId)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData)
//                     return Center(child: new CircularProgressIndicator());
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 15.0, left: 15.0),
//                     child: ListView(
//                       physics: BouncingScrollPhysics(),
//                       children:
//                           snapshot.data!.docs.map((DocumentSnapshot document) {
//                         String imageUrl = document['imgUrl'];
//                         return InkWell(
//                           onTap: () {
//                             navigateToDetail(snapshot.data!.docs[id]);
//                           },
// //                           onTap: () {

// //                             checkDoc
// //                                 ? null
// //                                 : FirebaseFirestore.instance
// //                                     .collection('order_count')
// //                                     .doc(user!.uid)
// //                                     .set({
// //                                     'userid': user!.uid,
// //                                     'count': 1,
// //                                   });
// //                             checkDocOr();
// //                             getFields();
// //                             // модалка
// //                             showModalBottomSheet<void>(
// //                               backgroundColor: Colors.transparent,
// //                               isScrollControlled: true,
// //                               context: context,
// //                               builder: (BuildContext context) {
// //                                 return Container(
// //                                   decoration: BoxDecoration(
// //                                       color: Colors.white,
// //                                       borderRadius: BorderRadius.only(
// //                                           topLeft: Radius.circular(15),
// //                                           topRight: Radius.circular(15))),
// //                                   margin: EdgeInsets.only(top: 80.0),
// //                                   height: MediaQuery.of(context).size.height,
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.only(
// //                                         left: 15, right: 15),
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       mainAxisAlignment:
// //                                           MainAxisAlignment.spaceAround,
// //                                       // mainAxisSize: MainAxisSize.min,
// //                                       children: <Widget>[
// //                                         Center(
// //                                           child: Container(
// //                                             margin: EdgeInsets.all(6.0),
// //                                             height: 5,
// //                                             width: 100,
// //                                             decoration: BoxDecoration(
// //                                                 color: Colors.grey[350],
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(8)),
// //                                           ),
// //                                         ),
// //                                         CachedNetworkImage(
// //                                           height: 350,
// //                                           imageUrl: '$imageUrl',
// //                                           imageBuilder:
// //                                               (context, imageProvider) =>
// //                                                   Container(
// //                                             decoration: BoxDecoration(
// //                                               borderRadius:
// //                                                   BorderRadius.circular(4),
// //                                               image: DecorationImage(
// //                                                 image: imageProvider,
// //                                                 fit: BoxFit.cover,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           placeholder: (context, url) => Center(
// //                                               child:
// //                                                   CircularProgressIndicator()),
// //                                           errorWidget: (context, url, error) =>
// //                                               Center(child: Icon(Icons.error)),
// //                                         ),
// //                                         Container(
// //                                           child: Text(document['name'],
// //                                               style: TextStyle(
// //                                                   fontSize: 24,
// //                                                   fontWeight: FontWeight.bold)),
// //                                         ),
// //                                         Text(
// //                                           document['price'].toString() +
// //                                               ' \u{20bd}',
// //                                           style: TextStyle(
// //                                               fontSize: 24,
// //                                               color: Colors.deepOrange),
// //                                         ),
// //                                         // SizedBox(height: 10),
// //                                         Text(document['subname'] ??
// //                                             'Описание отсутствует'),

// //                                         Row(
// //                                           children: [
// //                                             Spacer(),
// //                                             InkWell(
// //                                               child: Container(
// //                                                   padding: EdgeInsets.all(15),
// //                                                   decoration: BoxDecoration(
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               10),
// //                                                       border: Border.all(
// //                                                           color: Colors.green,
// //                                                           width: 2)),
// //                                                   child: Text('В корзину')),
// //                                               onTap: () {
// //                                                 if (vendRest == '') {
// //                                                   FirebaseFirestore.instance
// //                                                       .collection('orders')
// //                                                       .doc(user!.uid + '$guid')
// //                                                       .set({
// //                                                     'vendor':
// //                                                         document['vendorId'],
// //                                                     'user': user!.uid,
// //                                                     'ordercount': guid,
// //                                                     'status': 'processing'
// //                                                   });
// //                                                   FirebaseFirestore.instance
// //                                                       .collection('orders')
// //                                                       .doc(user!.uid + '$guid')
// //                                                       .collection('items')
// //                                                       .doc(
// //                                                           document['productId'])
// //                                                       .set({
// //                                                     'productId':
// //                                                         document['productId'],
// //                                                     'count': 1
// //                                                   });
// //                                                   getFields();
// //                                                   getRest();
// //                                                   print('orders + item + ');
// //                                                 } else if (vendRest ==
// //                                                     document['vendorId']) {
// //                                                   FirebaseFirestore.instance
// //                                                       .collection('orders')
// //                                                       .doc(user!.uid + '$guid')
// //                                                       .collection('items')
// //                                                       .doc(
// //                                                           document['productId'])
// //                                                       .set({
// //                                                     'productId':
// //                                                         document['productId'],
// //                                                     'count': 1
// //                                                   });
// //                                                   getFields();
// //                                                   getRest();
// //                                                   print('дописываем + ');
// //                                                 } else if (vendRest !=
// //                                                         document['vendorId'] &&
// //                                                     vendRest != '') {
// //                                                   // FirebaseFirestore.instance
// //                                                   //     .collection('orders')
// //                                                   //     .doc(user!.uid + '$guid')
// //                                                   //     .collection('items')
// //                                                   //     .snapshots()
// //                                                   //     .forEach((element) {
// //                                                   //   for (QueryDocumentSnapshot snapshot
// //                                                   //       in element.docs) {
// //                                                   //     snapshot.reference
// //                                                   //         .delete();
// //                                                   //   }
// //                                                   // });
// //                                                   getFields();
// //                                                   getRest();

// //                                                   print('очистили');
// //                                                   FirebaseFirestore.instance
// //                                                       .collection('orders')
// //                                                       .doc(user!.uid + '$guid')
// //                                                       .update({
// //                                                     'vendor':
// //                                                         document['vendorId'],
// //                                                   });
// //                                                   getRest();
// //                                                   print('сменили вендора');

// //                                                   print(
// //                                                       'очистить корзину и перезаписать + ');
// //                                                 } else {}

// // //
// // //
// // //                                                   //удаляет коллекцию

// // //                                                   showDialog<String>(
// // //                                                     context: context,
// // //                                                     builder: (BuildContext
// // //                                                             context) =>
// // //                                                         AlertDialog(
// // //                                                       content: Column(
// // //                                                         mainAxisAlignment:
// // //                                                             MainAxisAlignment
// // //                                                                 .center,
// // //                                                         mainAxisSize:
// // //                                                             MainAxisSize.min,
// // //                                                         children: [
// // //                                                           Text(
// // //                                                             'Внимание!',
// // //                                                             style: TextStyle(
// // //                                                                 fontSize: 20,
// // //                                                                 fontWeight:
// // //                                                                     FontWeight
// // //                                                                         .bold,
// // //                                                                 color: Colors
// // //                                                                     .deepOrange),
// // //                                                           ),
// // //                                                           Text(
// // //                                                               'В корзине могут быть товары только одного ресторана. Вы можете очистить корзину, или продолжить покупки.')
// // //                                                         ],
// // //                                                       ),
// // //                                                       actions: <Widget>[
// // //                                                         OutlinedButton(
// // //                                                           style: ButtonStyle(
// // //                                                               backgroundColor:
// // //                                                                   MaterialStateProperty
// // //                                                                       .all(Colors
// // //                                                                           .deepOrange)),
// // //                                                           onPressed: () {
// // //                                                             FirebaseFirestore
// // //                                                                 .instance
// // //                                                                 .collection(
// // //                                                                     'orders')
// // //                                                                 .doc(user!.uid +
// // //                                                                     '$guid')
// // //                                                                 .collection(
// // //                                                                     'items')
// // //                                                                 .snapshots()
// // //                                                                 .forEach(
// // //                                                                     (element) {
// // //                                                               for (QueryDocumentSnapshot snapshot
// // //                                                                   in element
// // //                                                                       .docs) {
// // //                                                                 snapshot
// // //                                                                     .reference
// // //                                                                     .delete();
// // //                                                               }
// // //                                                             });

// // //                                                             FirebaseFirestore
// // //                                                                 .instance
// // //                                                                 .collection(
// // //                                                                     'orders')
// // //                                                                 .doc(user!.uid +
// // //                                                                     '$guid')
// // //                                                                 .set({
// // //                                                               'vendor': document[
// // //                                                                   'vendorId'],
// // //                                                               'user': user!.uid,
// // //                                                               'ordercount':
// // //                                                                   guid,
// // //                                                               'status':
// // //                                                                   'processing'
// // //                                                             });

// // //                                                             Navigator.pop(
// // //                                                                 context, 'OK');
// // //                                                             getFields();
// // //                                                             getRest();
// // //                                                           },
// // //                                                           child: Text(
// // //                                                             'Очистить',
// // //                                                             style: TextStyle(
// // //                                                                 color: Colors
// // //                                                                     .white),
// // //                                                           ),
// // //                                                         ),
// // //                                                         OutlinedButton(
// // //                                                           onPressed: () =>
// // //                                                               Navigator.pop(
// // //                                                                   context,
// // //                                                                   'OK'),
// // //                                                           child: Text(
// // //                                                               'Продолжить'),
// // //                                                         )
// // //                                                       ],
// // //                                                     ),
// // //                                                   );

// // // //Перезаписываем и добовляем в корзину
// // //                                                   print('не тот вендор');
// // //                                                 } else if (vendRest ==
// // //                                                     document['vendorId']) {
// // // //Добовляем в корзину
// // //                                                   FirebaseFirestore.instance
// // //                                                       .collection('orders')
// // //                                                       .doc(user!.uid + '$guid')
// // //                                                       .collection('items')
// // //                                                       .doc(
// // //                                                           document['productId'])
// // //                                                       .set({
// // //                                                     'productId':
// // //                                                         document['productId'],
// // //                                                     'count': 1
// // //                                                   });
// // //                                                   getFields();
// // //                                                   getRest();
// // //                                                   print(
// // //                                                       'Здесь - add to basket');
// // //                                                 } else {}
// // //
// // //
// // //
// // //
// //                                                 // FirebaseFirestore.instance
// //                                                 //     .collection('orders')
// //                                                 //     .doc(user!.uid + '$guid')
// //                                                 //     .set({
// //                                                 //   'vendor':
// //                                                 //       document['vendorId'],
// //                                                 //   'user': user!.uid,
// //                                                 //   'ordercount': guid,
// //                                                 //   'status': 'processing'
// //                                                 // });
// //                                                 // getRest();
// //                                                 // FirebaseFirestore.instance
// //                                                 //     .collection('orders')
// //                                                 //     .doc(user!.uid + '$guid')
// //                                                 //     .collection('items')
// //                                                 //     .doc(document['productId'])
// //                                                 //     .set({
// //                                                 //   'productId':
// //                                                 //       document['productId'],
// //                                                 //   'count': 1
// //                                                 // });
// //                                                 // getFields();
// //                                               },
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         // SizedBox()
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                             );
// //                             getFields();
// //                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 20.0),
//                             child: Container(
//                               height: 130,
//                               child: Stack(
//                                 children: <Widget>[
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Container(
//                                       margin: EdgeInsets.only(right: 2),
//                                       width: MediaQuery.of(context).size.width *
//                                           .60,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(20),
//                                               bottomRight: Radius.circular(20)),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 blurRadius: 1,
//                                                 spreadRadius: 1,
//                                                 color: Colors.black12)
//                                           ]),
//                                       child: Stack(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(12.0),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: [
//                                                 Padding(
//                                                   padding: EdgeInsets.only(
//                                                       bottom: 5.0),
//                                                   child: Container(
//                                                     child: Text(
//                                                       document['name'],
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight
//                                                               .normal),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   child: Text(
//                                                     'Цена продукта: ' +
//                                                         document['price']
//                                                             .toString() +
//                                                         '\u{20bd}' +
//                                                         '\n' +
//                                                         document['vendorId'],
//                                                     style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Positioned(
//                                             bottom: 5,
//                                             right: 60,
//                                             child: Container(
//                                               height: 30,
//                                               width: 65,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.green,
//                                                 borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(10),
//                                                   bottomRight:
//                                                       Radius.circular(10),
//                                                 ),
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   document['price'].toString() +
//                                                       ' \u{20bd}',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 18,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                               bottom: 0,
//                                               right: 0,
//                                               child: FutureBuilder<
//                                                   DocumentSnapshot>(
//                                                 future: FirebaseFirestore
//                                                     .instance
//                                                     .collection('orders')
//                                                     .doc(user!.uid + '$guid')
//                                                     .collection('items')
//                                                     .doc(document['productId'])
//                                                     .get(),
//                                                 builder: (BuildContext context,
//                                                     AsyncSnapshot<
//                                                             DocumentSnapshot>
//                                                         snapshot) {
//                                                   if (snapshot.hasError) {
//                                                     return SizedBox();
//                                                   }

//                                                   if (snapshot.hasData &&
//                                                       !snapshot.data!.exists) {
//                                                     return Container(
//                                                       height: 40,
//                                                       width: 50,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.grey[600],
//                                                         borderRadius:
//                                                             BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   20),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   20),
//                                                         ),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.add,
//                                                         color: Colors.white,
//                                                       ),
//                                                     );
//                                                   }

//                                                   if (snapshot
//                                                           .connectionState ==
//                                                       ConnectionState.done) {
//                                                     Map<String, dynamic> data =
//                                                         snapshot.data!.data()
//                                                             as Map<String,
//                                                                 dynamic>;
//                                                     return Container(
//                                                       height: 40,
//                                                       width: 50,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.amber,
//                                                         borderRadius:
//                                                             BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   20),
//                                                           bottomRight:
//                                                               Radius.circular(
//                                                                   20),
//                                                         ),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.done,
//                                                         color: Colors.black,
//                                                       ),
//                                                     );
//                                                   }

//                                                   return Text(".");
//                                                 },
//                                               ))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: CachedNetworkImage(
//                                       imageUrl: document['imgUrl'],
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 .33,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.cover,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 blurRadius: 3,
//                                                 spreadRadius: 1,
//                                                 color: Colors.black12,
//                                               )
//                                             ]),
//                                       ),
//                                       placeholder: (context, url) =>
//                                           CircularProgressIndicator(),
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
// }
