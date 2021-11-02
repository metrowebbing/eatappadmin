import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatappadmin/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class Partners extends StatefulWidget {
  Partners({Key? key}) : super(key: key);

  @override
  _PartnersState createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  final name = TextEditingController();
  final city = TextEditingController();
  final phone = TextEditingController();
  final comment = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
          'Стать партнером',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('partners')
                .doc(user!.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:
                        Text("Не удалось загрузить данные. Попробуйте позже"),
                  ),
                );
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          'Заполните все поля',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Поле не заполнено';
                                    }
                                    return null;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: name,
                                  decoration: InputDecoration(
                                      labelText: 'Ваше имя',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Поле не заполнено';
                                    }
                                    return null;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: phone,
                                  decoration: InputDecoration(
                                      labelText: 'Телефон',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Поле не заполнено';
                                    }
                                    return null;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: city,
                                  decoration: InputDecoration(
                                      labelText: 'Город',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: comment,
                                  decoration: InputDecoration(
                                      labelText:
                                          'Название ресторана или комментарий',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('partners')
                                          .doc(user!.uid)
                                          .set({
                                        'name': name.text,
                                        'phone': phone.text,
                                        'city': city.text,
                                        'comment': comment.text
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Заявка отправлена.'),
                                            content: Text(
                                                'Мы рассмотрим Вашу заявку в ближайшее время.\nПожалуйста, не отправляйте повторных заявок.'),
                                            actions: [
                                              TextButton(
                                                child: const Text('Хорошо'),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return Profile();
                                                    }),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Заполните поля!'),
                                            content: Text(
                                                'Поля подсвеченные красным обязательны.'),
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
                                    'Отправить',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    )),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Ваша заявка на рассмотрении.\nМы свяжемся с Вами в ближайшее время.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }

              return Center(
                  child: CircularProgressIndicator(
                color: Colors.grey[300],
              ));
            },
          ),
        ),
      ),
    );
  }
}
