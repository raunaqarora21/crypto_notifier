import 'package:flutter/material.dart';

class PriceAlert extends StatefulWidget {
  @override
  _PriceAlertState createState() => _PriceAlertState();
}

class _PriceAlertState extends State<PriceAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Price Alert'),
      // ),
      body: Center(
        child: Container(
          child: SizedBox(
            height: 200.0,
            width: 200.0,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/download.png'),
              backgroundColor: Color(0xFFA93BF5),
            ),
          ),
        ),
      ),
    );
  }
}
