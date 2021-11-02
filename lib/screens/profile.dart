import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/partners.dart';
import 'package:eatappadmin/screens/politika.dart';
import 'package:eatappadmin/screens/userorders.dart';
import 'package:eatappadmin/widgets/menubar.dart';
import 'package:eatappadmin/widgets/updatecity.dart';
import 'package:eatappadmin/widgets/updatename.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          'Профиль',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(Icons.smartphone_outlined, color: Colors.blue),
                      title: Text(
                        '${user!.phoneNumber}',
                      ),
                    ),
                    Divider(),

                    // ListTile(
                    //   leading: Icon(Icons.person_outline_outlined,
                    //       color: Colors.green),
                    //   title: StreamBuilder<User?>(
                    //     stream: FirebaseAuth.instance.userChanges(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return Center(child: CircularProgressIndicator());
                    //       }
                    //       var name = snapshot.data!.displayName;
                    //       return Text('$name');
                    //     },
                    //   ),
                    //   trailing: TextButton(
                    //     child: Text('изменить'),
                    //     onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) {
                    //           return UpdateName();
                    //         }),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // Divider(),
                    ListTile(
                      leading:
                          Icon(Icons.location_on_outlined, color: Colors.pink),
                      title: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('user', isEqualTo: user!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: new CircularProgressIndicator());
                          return Row(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              String userCityNum = document['city'];

                              return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('city')
                                    .where('id', isEqualTo: userCityNum)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                        child: new CircularProgressIndicator());
                                  return Row(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      return Text(document['name']);
                                    }).toList(),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                      trailing: TextButton(
                        child: Text('изменить'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return UpdateCity();
                            }),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return UserOrders();
                          }),
                        );
                      },
                      leading: Icon(Icons.receipt_long_outlined,
                          color: Colors.deepOrange),
                      title: Text(
                        'Мои заказы',
                      ),
                      trailing: Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.deepOrange,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Partners();
                            }),
                          );
                        },
                        leading: Icon(
                          Icons.badge_outlined,
                          color: Colors.green,
                        ),
                        title: Text('Стать партнером'),
                        trailing: Icon(Icons.chevron_right_outlined,
                            color: Colors.deepOrange, size: 35)),
                    Divider(),
                    ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Politika();
                            }),
                          );
                        },
                        leading: Icon(
                          Icons.verified_user_outlined,
                          color: Colors.red,
                        ),
                        title: Text('Политика и условия'),
                        trailing: Icon(Icons.chevron_right_outlined,
                            color: Colors.deepOrange, size: 35)),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.device_unknown_outlined,
                        color: Colors.blue,
                      ),
                      title: Text('О приложении:'),
                      subtitle: Text(
                        '"Везём Еду" v.1.0.0',
                        style: TextStyle(color: Colors.blue),
                      ),
                      // trailing: Icon(Icons.chevron_right_outlined,
                      //     color: Colors.deepOrange, size: 35)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
      extendBody: true,
      bottomNavigationBar: MenuBar(params: 3),
    );
  }
}
