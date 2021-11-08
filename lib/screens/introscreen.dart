import 'package:eatappadmin/screens/log.dart';
import 'package:eatappadmin/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        styleTitle: TextStyle(
          color: Colors.deepOrange,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(color: Colors.green, fontSize: 24),
        title: "ВЫБИРАЙ",
        description: "Меню ресторанов и кафе твоего города в одном приложении.",
        pathImage: "assets/intro/screen1.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        styleTitle: TextStyle(
          color: Colors.deepOrange,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(color: Colors.green, fontSize: 24),
        title: "ЗАКАЗЫВАЙ",
        description: "Просто добавь в корзину и оформи заказ.",
        pathImage: "assets/intro/screen2.png",
        backgroundColor: Colors.white,
      ),
    );
    slides.add(
      new Slide(
        styleTitle: TextStyle(
          color: Colors.deepOrange,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        styleDescription: TextStyle(color: Colors.green, fontSize: 24),
        title: "ЖДИ КУРЬЕРА",
        description: "Подтверди свой заказ по телефону и жди курьера.",
        pathImage: "assets/intro/screen3.png",
        backgroundColor: Colors.white,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    print("End of slides");
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      showSkipBtn: false,
      renderPrevBtn: Text('Назад', style: TextStyle(color: Colors.white)),
      // renderSkipBtn: Text('ПРОПУСТИТЬ', style: TextStyle(color: Colors.white)),
      renderDoneBtn: Text('Начать', style: TextStyle(color: Colors.white)),
      renderNextBtn: Text('Далее', style: TextStyle(color: Colors.white)),
      doneButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            return Colors.green; // Use the component's default.
          },
        ),
      ),
      skipButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            return Colors.green; // Use the component's default.
          },
        ),
      ),
      prevButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            return Colors.green; // Use the component's default.
          },
        ),
      ),
      nextButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return Theme.of(context).colorScheme.primary.withOpacity(0.5);
            return Colors.green; // Use the component's default.
          },
        ),
      ),
      slides: this.slides,
      onDonePress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return LogScreen();
          }),
        );
      },
    );
  }
}
