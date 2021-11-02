import 'package:eatappadmin/screens/cartpage.dart';
import 'package:eatappadmin/screens/home.dart';
import 'package:eatappadmin/screens/profile.dart';
import 'package:eatappadmin/screens/userorders.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MenuBar extends StatefulWidget {
  final int params;
  MenuBar({Key? key, required this.params}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  @override
  Widget build(BuildContext context) {
    return FloatingNavbar(
      backgroundColor: Colors.green,
      onTap: (int val) {
        if (val == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return Home();
            }),
          );
        } else if (val == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return CartPage();
            }),
          );
        } else if (val == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return UserOrders();
            }),
          );
        } else if (val == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return Profile();
            }),
          );
        } else {}
        //returns tab id which is user tapped
      },
      currentIndex: widget.params,
      items: [
        FloatingNavbarItem(
            icon: Icons.restaurant_menu_outlined, title: 'Рестораны'),
        FloatingNavbarItem(
            icon: Icons.shopping_cart_outlined, title: 'Корзина'),
        FloatingNavbarItem(icon: Icons.receipt_long_outlined, title: 'Заказы'),
        FloatingNavbarItem(icon: Icons.person_outline, title: 'Профиль'),
      ],
    );
  }
}
