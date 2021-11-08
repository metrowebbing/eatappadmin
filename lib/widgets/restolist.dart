import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/detailpage_rest.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RestoList extends StatefulWidget {
  RestoList({Key? key}) : super(key: key);

  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String userCity = data['city'];

          return Container(
            padding: EdgeInsets.only(bottom: 25.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('cafe')
                 
                  .where('city', isEqualTo: userCity)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    String imgUrl = snapshot.data!.docs[index].get('imgUrl');
                    String active = snapshot.data!.docs[index].get('active');
                    num dost = snapshot.data!.docs[index].get('dost');
                    num balance = snapshot.data!.docs[index].get('balance');

                    String start = snapshot.data!.docs[index].get('startorder');
                    String end = snapshot.data!.docs[index].get('endorder');
                    String deltime = snapshot.data!.docs[index].get('deltime');
                    // start
                    DateTime tempDatestart = DateFormat("hh:mm").parse(start);
                    String cafestart =
                        DateFormat('kk.mm').format(tempDatestart);
                    String starttoorder =
                        DateFormat('kk:mm').format(tempDatestart);
                    // end
                    DateTime tempDateend = DateFormat("hh:mm").parse(end);
                    String cafeend = DateFormat('kk.mm').format(tempDateend);
                    String endtoorder = DateFormat('kk:mm').format(tempDateend);
                    // now
                    DateTime now = DateTime.now();
                    String timenow = DateFormat('kk.mm').format(now);
                    // String timenow = DateFormat('kk:mm').format(tempDateNow);

                    double varNow = double.parse(timenow);
                    double varStart = double.parse(cafestart);
                    double varEnd = double.parse(cafeend);

                    varStart < varEnd
                        ? varEnd = varEnd
                        : varEnd = 24.00 + varEnd;
                    bool work = false;
                    varNow > varStart && varNow < varEnd
                        ? work = true
                        : work = false;

                    return active == '0'
                        ? SizedBox()
                        : balance < 0
                            ? SizedBox()
                            : InkWell(
                                onTap: () {
                                  work == false
                                      ? null
                                      : navigateToDetail(
                                          snapshot.data!.docs[index]);
                                },
                                child: Card(
                                  margin: EdgeInsets.all(15),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: imgUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(0.9),
                                                        Colors.black
                                                            .withOpacity(0.2)
                                                      ]),
                                                ),
                                              ),
                                              height: 150,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) => Center(
                                                    child: Icon(Icons.error)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 4),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: snapshot
                                                              .data!.docs[index]
                                                              .get('name') +
                                                          '\n',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: Colors.white)),
                                                  WidgetSpan(
                                                      child: Icon(
                                                    Icons.access_time_outlined,
                                                    size: 16,
                                                    color: Colors.yellow,
                                                  )),
                                                  TextSpan(
                                                      text:
                                                          ' $starttoorder - $endtoorder',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.yellow))
                                                ],
                                              ),
                                            ),
                                          ),
                                          work == true
                                              ? SizedBox()
                                              : Positioned(
                                                  top: 10,
                                                  left: 10,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                            child: Icon(
                                                              Icons
                                                                  .access_time_outlined,
                                                              size: 15,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                              text: ' Закрыто',
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red))
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              padding: EdgeInsets.fromLTRB(
                                                  6, 4, 6, 4),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black12,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.delivery_dining,
                                                        size: 16,
                                                        color:
                                                            Colors.deepOrange,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            ' от $dost \u{20bd} ~$deltime мин',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15.0),
                                              padding: EdgeInsets.fromLTRB(
                                                  6, 4, 6, 4),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black12,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: RichText(
                                                text: TextSpan(children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      size: 16,
                                                      color: Colors.green[700],
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: ' от ' +
                                                          snapshot
                                                              .data!.docs[index]
                                                              .get('minprice')
                                                              .toString() +
                                                          ' \u{20bd}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black87))
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
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

        return Center(
            child: CircularProgressIndicator(color: Colors.grey[300]));
      },
    );
  }
}

