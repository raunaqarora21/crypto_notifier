import 'dart:convert';
import 'dart:developer';

import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:crypto_notifier/screens/mainApp/subscribe/subscribeScreen.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

class SubscribeButton extends StatefulWidget {
  final String coinName;
  final String coinId;
  final AppData appData;
  SubscribeButton({this.coinName, this.coinId, this.appData});
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

    if (widget.appData.subList.contains(widget.coinId)) {
      log("Contains");
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
    return StarButton(
      isStarred: subScribe,
      valueChanged: (_isStarred) {
        setState(() {
          if (title == "Subscribe") {
            widget.appData.addtoSub(widget.coinName, widget.coinId);

            title = 'Unsubscribe';
            color = Colors.redAccent;
          } else {
            widget.appData.deleteSub(widget.coinName, widget.coinId);

            subScribe = false;
            title = 'Subscribe';
            color = Colors.grey;
          }
          widget.appData.loadData();
        });
      },
    );
  }
}
