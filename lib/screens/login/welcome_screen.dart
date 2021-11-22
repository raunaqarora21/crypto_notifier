import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Align(
            child: ScaleTransition(
          scale: Tween(begin: 1.5, end: 2.0)
              .animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
          child: SizedBox(
            height: 80.0,
            width: 100.0,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/download.png'),
              backgroundColor: Color(0xFFA93BF5),
              minRadius: 50.0,
              maxRadius: 100.0,
            ),
          ),
        )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.0,
            ),
            Text(
              'Create a free account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            RoundButton(
              title: 'Create an account',
              color: Color(0xFF121BF1),
              onPress: () {
                Navigator.pushNamed(context, 'RegistrationScreen');
              },
            ),
            RoundButton(
              title: 'Login',
              color: Color(0xFF47487B),
              onPress: () {
                Navigator.pushNamed(context, 'LoginScreen');
              },
            ),
          ],
        )
      ])),
    );
  }
}
