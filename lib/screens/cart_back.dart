// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eatappadmin/screens/detailpage_prod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// var user = FirebaseAuth.instance.currentUser;

// CollectionReference<Map<String, dynamic>> allCollection =
//     FirebaseFirestore.instance.collection('products');

// class CartPage extends StatefulWidget {
//   CartPage({Key? key}) : super(key: key);

//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   navigateToDetail(DocumentSnapshot prod) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => DetailProduct(
//                   prod: prod,
//                 )));
//   }

//   @override
//   void initState() {
//     super.initState();
//     getFields();
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               flex: 90,
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('orders')
//                     .doc(user!.uid + '$guid')
//                     .collection('items')
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData)
//                     return Center(child: CircularProgressIndicator());
//                   final _documents = snapshot.data!.docs;
//                   return ListView.builder(
//                     // physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     itemCount: _documents.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       String prodId = _documents[index].get('productId');
//                       int prodCount = _documents[index].get('count');
//                       int prodPrice = _documents[index].get('price');

//                       return Container(
//                           //

//                           child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('products')
//                             .where('productId', isEqualTo: prodId)
//                             .snapshots(),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (!snapshot.hasData)
//                             return Center(child: CircularProgressIndicator());
//                           final proddoc = snapshot.data!.docs;
//                           return ListView.builder(
//                             physics: BouncingScrollPhysics(),
//                             shrinkWrap: true,
//                             scrollDirection: Axis.vertical,
//                             itemCount: proddoc.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               String name = proddoc[index].get('name');
//                               int price = proddoc[index].get('price');

//                               String image = proddoc[index].get('imgUrl');

//                               return Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Container(
//                                   height: 120,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(10)),
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           flex: 30,
//                                           child: CachedNetworkImage(
//                                             imageUrl: image,
//                                             imageBuilder:
//                                                 (context, imageProvider) =>
//                                                     Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 image: DecorationImage(
//                                                   image: imageProvider,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 55,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   flex: 40,
//                                                   child: Text(
//                                                     name,
//                                                     style: TextStyle(
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Container(
//                                                         child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: Container(
//                                                         decoration: BoxDecoration(
//                                                             color: Colors
//                                                                 .grey[200],
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         5)),
//                                                         child: Row(
//                                                           children: [
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'orders')
//                                                                     .doc(user!
//                                                                             .uid +
//                                                                         '$guid')
//                                                                     .collection(
//                                                                         'items')
//                                                                     .doc(prodId)
//                                                                     .update({
//                                                                   'count': FieldValue
//                                                                       .increment(
//                                                                           -1)
//                                                                 });
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'orders')
//                                                                     .doc(user!
//                                                                             .uid +
//                                                                         '$guid')
//                                                                     .update({
//                                                                   'itemsCount':
//                                                                       FieldValue
//                                                                           .increment(
//                                                                               -1)
//                                                                 });
//                                                                 getFields();
//                                                               },
//                                                               child: Container(
//                                                                   height: 30,
//                                                                   width: 30,
//                                                                   decoration: BoxDecoration(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                       color: Colors
//                                                                           .orange),
//                                                                   child: Center(
//                                                                       child:
//                                                                           Icon(
//                                                                     Icons
//                                                                         .remove,
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ))),
//                                                             ),
//                                                             Container(
//                                                                 height: 30,
//                                                                 width: 30,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .circular(
//                                                                                 5),
//                                                                     color: Colors
//                                                                         .transparent),
//                                                                 child: Center(
//                                                                     child: Text(
//                                                                         prodCount
//                                                                             .toString()))),
//                                                             InkWell(
//                                                               onTap: () {
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'orders')
//                                                                     .doc(user!
//                                                                             .uid +
//                                                                         '$guid')
//                                                                     .collection(
//                                                                         'items')
//                                                                     .doc(prodId)
//                                                                     .update({
//                                                                   'count':
//                                                                       FieldValue
//                                                                           .increment(
//                                                                               1)
//                                                                 });
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'orders')
//                                                                     .doc(user!
//                                                                             .uid +
//                                                                         '$guid')
//                                                                     .update({
//                                                                   'itemsCount':
//                                                                       FieldValue
//                                                                           .increment(
//                                                                               1)
//                                                                 });
//                                                                 getFields();
//                                                               },
//                                                               child: Container(
//                                                                   height: 30,
//                                                                   width: 30,
//                                                                   decoration: BoxDecoration(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                       color: Colors
//                                                                           .green),
//                                                                   child: Center(
//                                                                       child:
//                                                                           Icon(
//                                                                     Icons.add,
//                                                                     color: Colors
//                                                                         .white,
//                                                                   ))),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )),
//                                                     Container(
//                                                       child: RichText(
//                                                         text: TextSpan(
//                                                           children: [
//                                                             WidgetSpan(
//                                                               child: Text(
//                                                                   price
//                                                                       .toString(),
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           20,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold)),
//                                                             ),
//                                                             WidgetSpan(
//                                                               child: Text(
//                                                                   ' \u{20bd}',
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           20)),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                             flex: 15,
//                                             child: Icon(Icons.delete_forever,
//                                                 size: 30, color: Colors.red))
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       )
//                           //
//                           );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               flex: 10,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(child: Text('Итого- ')),
//                   Container(
//                     child: FutureBuilder<QuerySnapshot>(
//                       future: FirebaseFirestore.instance
//                           .collection('orders')
//                           .doc(user!.uid + '$guid')
//                           .collection('items')
//                           .get(),
//                       builder: (BuildContext context, snapshot) {
//                         if (snapshot.hasError)
//                           return Text('Something went wrong');
//                         if (snapshot.connectionState == ConnectionState.waiting)
//                           return SizedBox();

//                         num total = 0;
//                         snapshot.data!.docs.forEach((result) {
//                           total += (result.data() as dynamic)['count'] *
//                               (result.data() as dynamic)['price'];
//                         });
//                         print(total);
//                         print('done');
//                         return Text(total.toString());
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
