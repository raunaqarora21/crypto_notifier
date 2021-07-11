import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/screens/allCryptoScreen.dart';
import 'package:crypto_notifier/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/LoginScreen.dart';

import 'screens/RegistrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CryptoNotifier());
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
          primaryColor: Color(0xFF181631),
          //primaryColor: Colors.white,

          scaffoldBackgroundColor: Color(0xFF181631),
        ),
        home: WelcomeScreen(),
        routes: {
          'LoginScreen': (context) => LoginScreen(),
          'RegistrationScreen': (context) => RegisterationScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
