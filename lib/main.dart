import 'dart:async';

import 'package:crypto_notifier/helper/subScribed_coins.dart';

import 'package:crypto_notifier/screens/login/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/login/LoginScreen.dart';

import 'screens/login/RegistrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerPeriodicTask("2", "simplePeriodicTask");
  runApp(CryptoNotifier());
}

const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    switch (task) {
      case simplePeriodicTask:
        _showNotificationWithDefaultSound(
            flip, "Bitcoin", "The rate is lower than your limit.");
        break;
      case simplePeriodic1HourTask:
        _showNotificationWithDefaultSound(
            flip, "Cardano", "The rate is higher than your limit.");
        break;
    }

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(
    flip, String title, String subTitle) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(0, title, subTitle, platformChannelSpecifics,
      payload: 'Default_Sound');
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class CryptoNotifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF1F2630),
          // #181631
          //primaryColor: Colors.white,

          scaffoldBackgroundColor: Color(0xFF1F2630),
        ),
        home: SplashScreen(),
        routes: {
          'LoginScreen': (context) => LoginScreen(),
          'RegistrationScreen': (context) => RegisterationScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
//how to give circle border to image

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1F2630),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100.0,
                width: 100.0,
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/download.png'),
                  backgroundColor: Color(0xFFA93BF5),
                  minRadius: 50.0,
                  maxRadius: 150.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Crypto Notifier',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
