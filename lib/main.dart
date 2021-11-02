import 'package:eatappadmin/screens/home.dart';
import 'package:eatappadmin/screens/introscreen.dart';
import 'package:eatappadmin/screens/log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

var user = FirebaseAuth.instance.currentUser;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// var user = FirebaseAuth.instance.currentUser;

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           scaffoldBackgroundColor: Colors.grey[100],
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           primarySwatch: Colors.green,
//           textTheme: GoogleFonts.robotoTextTheme(
//             Theme.of(context).textTheme,
//           )),
//       home: UserOrders(),
//       // home: user == null ? Login() : Home(),
//     );
//   }
// }

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final DatabaseReference _database = FirebaseDatabase().reference();
  late FirebaseMessaging _fcm;
  late String message;
  late String token;

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    // getToken();
  }

  // getToken();

  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }

  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //   // if (message.data['type'] == 'chat') {
  //   //   Navigator.pushNamed(context, '/chat',
  //   //     arguments: ChatArguments(message),
  //   //   );
  //   // }
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   // Run code required to handle interacted messages in an async function
  //   // as initState() must not be async
  //   setupInteractedMessage();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          )),
      home: user == null ? IntroScreen() : Home(),
      // home: LogScreen(),
    );
  }

  // getToken() async {
  //   token = (await FirebaseMessaging.instance.getToken())!;
  //   setState(() {
  //     token = token;
  //   });
  //   final FirebaseFirestore _database = FirebaseFirestore.instance;
  //   _database.collection('users').doc(user!.uid).update({"token": token});
  // }
}
