import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;

class OrderForm extends StatefulWidget {
  OrderForm({Key? key}) : super(key: key);

  @override
  OrderFormState createState() => OrderFormState();
}

class OrderFormState extends State<OrderForm> {
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
    }
    if (user!.displayName == '') {
      contRname.text = "";
    } else {
      contRname.text = '${user!.displayName}';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Center(
                          child: Text('Оформление заказа',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)))),
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
                              Text('Контактные данные',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                controller: contRname,
                                decoration: InputDecoration(
                                    labelText: 'Ваше имя',
                                    // label: Text('Ваше имя'),
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
                                keyboardType: TextInputType.phone,
                                controller: contRphone,
                                decoration: InputDecoration(
                                    labelText: 'Ваше телефон',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                              Text('Адрес доставки',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                controller: contRstreet,
                                decoration: InputDecoration(
                                    labelText: 'Улица',
                                    // label: Text('Ваше имя'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: contRnomer,
                                      decoration: InputDecoration(
                                          labelText: 'Дом',
                                          // label: Text('Ваше имя'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: contRpodezd,
                                      decoration: InputDecoration(
                                          labelText: 'Подъезд',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: contRkvartira,
                                      decoration: InputDecoration(
                                          labelText: 'Квартира',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
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
                              Text('Комментарий к заказу',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              TextFormField(
                                maxLines: 2,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: contRcomment,
                                decoration: InputDecoration(
                                    labelText: 'Текст комментария',
                                    // label: Text('Ваше имя'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
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
                          user!.updateDisplayName(contRname.text);

                          FirebaseFirestore.instance
                              .collection('orders')
                              .doc(user!.uid)
                              .update({
                            'name': contRname.text,
                            'phone': contRphone.text,
                            'street': contRstreet.text,
                            'dom': contRnomer.text,
                            'podezd': contRpodezd.text,
                            'kvartira': contRkvartira.text,
                            'comment': contRcomment.text
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Заполните все поля!'),
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
                        'Оформить заказ',
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
      ),
    );
  }
}
