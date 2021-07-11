import 'dart:convert';

import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:crypto_notifier/screens/subscribeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

class SubscribeButton extends StatefulWidget {
  final String coinName;
  final String coinId;
  SubscribeButton({this.coinName, this.coinId});
  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {
  bool subScribe = false;
  String title = 'Subscribe';
  String id, symbol, name, marketCapUsd, priceUsd;
  Color color;

  @override
  void initState() {
    super.initState();

    if (context.read<AppData>().subList.contains(widget.coinId)) {
      title = 'Unsubscribe';
      subScribe = true;
      color = Colors.redAccent;
    } else {
      subScribe = false;
      title = 'Subscribe';
      color = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              if (title == "Subscribe") {
                Provider.of<AppData>(context, listen: false)
                    .addtoSub(widget.coinName, widget.coinId);

                title = 'Unsubscribe';
                color = Colors.redAccent;
              } else {
                Provider.of<AppData>(context, listen: false)
                    .deleteSub(widget.coinName, widget.coinId);

                subScribe = false;
                title = 'Subscribe';
                color = Colors.grey;
              }
              Provider.of<AppData>(context, listen: false).loadData();
            });
          },
          minWidth: 330.0,
          height: 70.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 25.0),
          ),
        ),
      ),
    );
  }
}
