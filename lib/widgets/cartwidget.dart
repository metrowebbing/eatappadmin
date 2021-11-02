import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/cartpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class CartWidget extends StatefulWidget {
  CartWidget({Key? key}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();

    getFields();
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return CartPage();
          }),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: 50,
            height: 40,
            child: Icon(Icons.shopping_cart, color: Colors.black54, size: 30),
          ),
          guid == 0
              ? SizedBox()
              : Positioned(
                  top: 5,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    width: 19,
                    height: 19,
                    child: Center(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('user', isEqualTo: user!.uid)
                            .where('ordercount', isEqualTo: guid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: Text('.'));
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: Text(
                                  snapshot.data!.docs[index]
                                      .get('itemsCount')
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
