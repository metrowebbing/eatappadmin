import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/detailpage_prod.dart';
import 'package:eatappadmin/screens/userorders.dart';
import 'package:eatappadmin/widgets/menubar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var user = FirebaseAuth.instance.currentUser;

bool onTapVal = true;

CollectionReference<Map<String, dynamic>> allCollection =
    FirebaseFirestore.instance.collection('products');

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  navigateToDetail(DocumentSnapshot prod) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailProduct(
                  prod: prod,
                )));
  }

  final contRname = TextEditingController();
  final contRphone = TextEditingController();
  final contRstreet = TextEditingController();
  final contRnomer = TextEditingController();
  final contRpodezd = TextEditingController();
  final contRkvartira = TextEditingController();
  final contRcomment = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    contRphone.dispose();
    contRname.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (user!.phoneNumber == '') {
      contRphone.text = "";
    } else {
      contRphone.text = '${user!.phoneNumber}';
      contRname.text = '${user!.displayName}';
    }
    getFields();
    super.initState();
  }

  var guid = 0;
  var vendorName = '';

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
    FirebaseFirestore.instance
        .collection('orders')
        .where('user', isEqualTo: user!.uid)
        .where('status', isEqualTo: 'processing')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        vendorName = doc["vendor"];
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
          'Корзина',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('order_count')
            .doc(user!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            int guid = data['count'];
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .doc(user!.uid + '$guid')
                        .collection('items')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      final proddoc = snapshot.data!.docs;
                      return proddoc.isEmpty
                          ? Center(
                              child: Icon(Icons.receipt_long,
                                  size: 150, color: Colors.grey[400]))
                          : Container(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: proddoc.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String name = proddoc[index].get('name');
                                  num price = proddoc[index].get('price');
                                  String image = proddoc[index].get('image');
                                  String prodId =
                                      proddoc[index].get('productId');
                                  num prodCount = proddoc[index].get('count');

                                  return Dismissible(
                                    background: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Icon(
                                                Icons.delete_forever_outlined,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Icon(
                                                Icons.delete_forever_outlined,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(user!.uid + '$guid')
                                            .collection('items')
                                            .doc(prodId)
                                            .delete();

                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(user!.uid + '$guid')
                                            .update({
                                          'itemsCount':
                                              FieldValue.increment(-prodCount)
                                        });
                                      });
                                    },
                                    key: UniqueKey(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height: 120,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 30,
                                                child: CachedNetworkImage(
                                                    imageUrl: image,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Center(
                                                            child: Icon(Icons
                                                                .image_not_supported))),
                                              ),
                                              Expanded(
                                                flex: 55,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 40,
                                                        child: Text(
                                                          name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Row(
                                                                children: [
                                                                  prodCount > 1
                                                                      ?

                                                                      //
                                                                      //
                                                                      InkWell(
                                                                          onDoubleTap:
                                                                              null,
                                                                          onTap: onTapVal == true
                                                                              ? () {
                                                                                  FirebaseFirestore.instance.collection('orders').doc(user!.uid + '$guid').collection('items').doc(prodId).update({
                                                                                    'count': FieldValue.increment(-1)
                                                                                  });
                                                                                  FirebaseFirestore.instance.collection('orders').doc(user!.uid + '$guid').update({
                                                                                    'itemsCount': FieldValue.increment(-1)
                                                                                  });
                                                                                  getFields();
                                                                                  setState(() {
                                                                                    onTapVal = false;
                                                                                  });
                                                                                  Timer(Duration(milliseconds: 500), () {
                                                                                    setState(() {
                                                                                      onTapVal = true;
                                                                                    });
                                                                                  });
                                                                                }
                                                                              : null,
                                                                          child: Container(
                                                                              height: 30,
                                                                              width: 30,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.orange),
                                                                              child: Center(
                                                                                  child: Icon(
                                                                                Icons.remove,
                                                                                color: Colors.white,
                                                                              ))),
                                                                        )

                                                                      //
                                                                      : Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              color: Colors.orange[100]),
                                                                          child: Center(
                                                                              child: Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                Colors.white,
                                                                          ))),

                                                                  // - //

                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          color: Colors
                                                                              .transparent),
                                                                      child: Center(
                                                                          child:
                                                                              Text(prodCount.toString()))),
                                                                  InkWell(
                                                                    onDoubleTap:
                                                                        null,
                                                                    onTap: () {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'orders')
                                                                          .doc(user!.uid +
                                                                              '$guid')
                                                                          .collection(
                                                                              'items')
                                                                          .doc(
                                                                              prodId)
                                                                          .update({
                                                                        'count':
                                                                            FieldValue.increment(1)
                                                                      });
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'orders')
                                                                          .doc(user!.uid +
                                                                              '$guid')
                                                                          .update({
                                                                        'itemsCount':
                                                                            FieldValue.increment(1)
                                                                      });

                                                                      getFields();
                                                                      setState(
                                                                          () {
                                                                        onTapVal =
                                                                            false;
                                                                      });
                                                                      Timer(
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          onTapVal =
                                                                              true;
                                                                        });
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                        height: 30,
                                                                        width: 30,
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
                                                                        child: Center(
                                                                            child: Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.white,
                                                                        ))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          Container(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                    child: Text(
                                                                        price
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ),
                                                                  WidgetSpan(
                                                                    child: Text(
                                                                        ' \u{20bd}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize: 20)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
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
                  )
                      //

                      ),
                  Container(
                    height: 125,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('cafe')
                          .where('vendorId', isEqualTo: vendorName)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return Center(child: Text('.'));
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            num minPrice =
                                snapshot.data!.docs[index].get('minprice');
                            num dost = snapshot.data!.docs[index].get('dost');
                            //
                            String start =
                                snapshot.data!.docs[index].get('startorder');
                            String end =
                                snapshot.data!.docs[index].get('endorder');

                            // start
                            DateTime tempDatestart =
                                DateFormat("hh:mm").parse(start);
                            String cafestart =
                                DateFormat('kk.mm').format(tempDatestart);
                            String starttoorder =
                                DateFormat('kk:mm').format(tempDatestart);
                            // end
                            DateTime tempDateend =
                                DateFormat("hh:mm").parse(end);
                            String cafeend =
                                DateFormat('kk.mm').format(tempDateend);
                            String endtoorder =
                                DateFormat('kk:mm').format(tempDateend);
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
                            //
                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(user!.uid + '$guid')
                                  .collection('items')
                                  .get(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasError)
                                  return Text('Something went wrong');
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Center(
                                      child: CircularProgressIndicator());

                                num total = 0;
                                snapshot.data!.docs.forEach((result) {
                                  total += (result.data() as dynamic)['count'] *
                                      (result.data() as dynamic)['price'];
                                });

                                var razn = minPrice - total;

                                minPrice < total ? dost = 0 : dost = dost;

                                var sumOrder = total + dost;

                                return total <= 0
                                    ? SizedBox()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            total < minPrice
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    color: Colors.red,
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Закажите еще на ' +
                                                              razn.toString() +
                                                              ' р. для бесплатной доставки',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          right: 15),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Сумма: ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                          Text('Доставка: ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                          Text('Итого: ',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      )),
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(total.toString(),
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text(dost.toString(),
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                        Text(
                                                            sumOrder.toString(),
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  work == false
                                                      ? Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                              'Заведение уже закрыто!\nзаказы принимаются\nс $starttoorder до $endtoorder',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders')
                                                                .doc(user!.uid +
                                                                    '$guid')
                                                                .update({
                                                              'total': total,
                                                              'dost': dost,
                                                              'sumOrder':
                                                                  sumOrder
                                                            });

                                                            showModalBottomSheet<
                                                                void>(
                                                              isScrollControlled:
                                                                  true,
                                                              enableDrag: false,
                                                              isDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SingleChildScrollView(
                                                                  // height:
                                                                  //     MediaQuery.of(context)
                                                                  //         .size
                                                                  //         .height,
                                                                  // color: Colors.amber,
                                                                  child:
                                                                      AnimatedPadding(
                                                                    padding: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets,
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            100),
                                                                    curve: Curves
                                                                        .decelerate,
                                                                    child: Form(
                                                                      key:
                                                                          _formKey,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(15.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.only(top: 50),
                                                                                child: Center(child: Text('Оформление заказа', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(vertical: 10),
                                                                              width: double.infinity,
                                                                              child: Card(
                                                                                color: Colors.white,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.all(20.0),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('Контактные данные', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        SizedBox(height: 20),
                                                                                        TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Поле не заполнено';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          textCapitalization: TextCapitalization.sentences,
                                                                                          controller: contRname,
                                                                                          decoration: InputDecoration(
                                                                                              labelText: 'Ваше имя',
                                                                                              // label: Text('Ваше имя'),
                                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                        ),
                                                                                        SizedBox(height: 20),
                                                                                        TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Поле не заполнено';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          keyboardType: TextInputType.phone,
                                                                                          controller: contRphone,
                                                                                          decoration: InputDecoration(labelText: 'Ваше телефон', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                        ),
                                                                                        // phone
                                                                                      ],
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(vertical: 10),
                                                                              width: double.infinity,
                                                                              child: Card(
                                                                                color: Colors.white,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.all(20.0),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('Адрес доставки', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        SizedBox(height: 20),
                                                                                        TextFormField(
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Поле не заполнено';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          textCapitalization: TextCapitalization.sentences,
                                                                                          controller: contRstreet,
                                                                                          decoration: InputDecoration(
                                                                                              labelText: 'Улица',
                                                                                              // label: Text('Ваше имя'),
                                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                        ),
                                                                                        SizedBox(height: 20),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: TextFormField(
                                                                                                validator: (value) {
                                                                                                  if (value == null || value.isEmpty) {
                                                                                                    return 'Поле не заполнено';
                                                                                                  }
                                                                                                  return null;
                                                                                                },
                                                                                                textCapitalization: TextCapitalization.sentences,
                                                                                                controller: contRnomer,
                                                                                                decoration: InputDecoration(
                                                                                                    labelText: 'Дом',
                                                                                                    // label: Text('Ваше имя'),
                                                                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: TextFormField(
                                                                                                keyboardType: TextInputType.number,
                                                                                                textCapitalization: TextCapitalization.sentences,
                                                                                                controller: contRpodezd,
                                                                                                decoration: InputDecoration(labelText: 'Подъезд', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 20,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: TextFormField(
                                                                                                keyboardType: TextInputType.number,
                                                                                                textCapitalization: TextCapitalization.sentences,
                                                                                                controller: contRkvartira,
                                                                                                decoration: InputDecoration(labelText: 'Квартира', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.symmetric(vertical: 10),
                                                                              width: double.infinity,
                                                                              child: Card(
                                                                                color: Colors.white,
                                                                                child: Padding(
                                                                                    padding: const EdgeInsets.all(20.0),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('Комментарий к заказу', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        SizedBox(height: 20),
                                                                                        TextFormField(
                                                                                          maxLines: 2,
                                                                                          textCapitalization: TextCapitalization.sentences,
                                                                                          controller: contRcomment,
                                                                                          decoration: InputDecoration(
                                                                                              labelText: 'Текст комментария',
                                                                                              // label: Text('Ваше имя'),
                                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                                                                        ),
                                                                                        SizedBox(height: 20),
                                                                                      ],
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: double.infinity,
                                                                              height: 60,
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    FirebaseFirestore.instance.collection('orders').doc(user!.uid + '$guid').update({
                                                                                      'status': 'ordering',
                                                                                      'name': contRname.text,
                                                                                      'phone': contRphone.text,
                                                                                      'street': contRstreet.text,
                                                                                      'dom': contRnomer.text,
                                                                                      'podezd': contRpodezd.text,
                                                                                      'kvartira': contRkvartira.text,
                                                                                      'comment': contRcomment.text,
                                                                                      'date': DateTime.now()
                                                                                    });
                                                                                    FirebaseFirestore.instance.collection('order_count').doc(user!.uid).update({
                                                                                      'count': FieldValue.increment(1)
                                                                                    });
                                                                                    user!.updateDisplayName(contRname.text);
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) {
                                                                                        return UserOrders();
                                                                                      }),
                                                                                    );
                                                                                  } else {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return AlertDialog(
                                                                                          title: Text('Заполните все поля!'),
                                                                                          content: Text('Поля подсвеченные красным обязательны.'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              child: const Text('Хорошо'),
                                                                                              onPressed: () {
                                                                                                Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                },
                                                                                child: const Text(
                                                                                  'Оформить',
                                                                                  style: TextStyle(fontSize: 20),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 40,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .deepOrange,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(15),
                                                                child: Text(
                                                                  'Оформить',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
              child: CircularProgressIndicator(color: Colors.grey[300]));
        },
      ),
      extendBody: true,
      bottomNavigationBar: MenuBar(params: 1),
    );
  }
}
