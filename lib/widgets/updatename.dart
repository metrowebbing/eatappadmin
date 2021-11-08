import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var user = FirebaseAuth.instance.currentUser;

final newNameController = TextEditingController();

class UpdateName extends StatelessWidget {
  const UpdateName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: newNameController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              maxLength: 10,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Новое имя',
                fillColor: Colors.transparent,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                user!.updateDisplayName(newNameController.text);
                Navigator.pop(context);
              },
              child: Center(
                  child:
                      Text('Сохранить', style: TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    ));
  }
}
