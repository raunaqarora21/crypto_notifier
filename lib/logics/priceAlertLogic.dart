import 'dart:developer' as dev;
import 'dart:math';

import 'package:crypto_notifier/helper/data.dart';
import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PriceAlertLogic extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<PriceAlertInfo> _priceAlerts = [
    // PriceAlertInfo(low: "4", high: "5", name: "Bitcoin")
  ];

  // List<PriceAlertInfo> get priceAlerts => _priceAlerts;
  List<PriceAlertTileInfo> _priceAlertTiles = [];
  List<PriceAlertTileInfo> get priceAlertTiles => _priceAlertTiles;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<InfoTile> coinInfo;
  var temp;
  List<String> coinNames = [];
  PriceAlertLogic() {
    _isLoading = true;

    notifyListeners();
    _getPriceAlerts();
  }

  _getPriceAlerts() async {
    _priceAlerts = [];
    _priceAlertTiles = [];
    coinNames = [];

    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;
    if (coinInfo == null || coinInfo.isEmpty) {
      Data info = Data();
      await info.getData();
      coinInfo = info.list;
    }

    //retrieve price alerts from database
    final DatabaseReference _database =
        FirebaseDatabase.instance.reference().child("users").child(uid);
    await _database.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        // dev.log(values.toString());
        if (key == "priceAlerts") {
          value.forEach((key, value) {
            // dev.log(value.toString());
            // coinNames.add(key);
            _priceAlerts.add(PriceAlertInfo(
              low: value["low"],
              high: value["high"],
              name: value["name"],
            ));
          });
        }
      });
    });

    for (InfoTile i in coinInfo) {
      for (PriceAlertInfo p in _priceAlerts) {
        if (i.name == p.name && coinNames.contains(i.name) == false) {
          coinNames.add(i.name);
          var low = p.low != null ? double.parse(p.low.replaceAll('%', '')) : 0;
          var high =
              p.high != null ? double.parse(p.high.replaceAll('%', '')) : 0;
          var percent = i.changePercent != null
              ? double.parse(i.changePercent.replaceAll('%', ''))
              : null;
          if (percent != null) {
            // dev.log(percent.toString());
            // dev.log(high.toString());
            // dev.log(i.name);
            if (percent > high) {
              await showNotification(i.name, "It's time to sell.", '');
            } else if (percent < low) {
              await showNotification(i.name, "It's time to buy more.", '');
            } else if (percent > low && percent < high) {}
            // dev.log(i.name);

            _priceAlertTiles.add(PriceAlertTileInfo(
              name: i.name,
              priceUsd: i.priceUsd,
              changePercent: i.changePercent,
              low: p.low,
              high: p.high,
              id: i.id,
              symbol: i.symbol,
            ));

            // log(i.changePercent);
          }
        }
      }
    }
    // dev.log(_priceAlertTiles.toString());

    _isLoading = false;
    notifyListeners();
  }

  addPriceAlert(String name, String high, String low) async {
    final newPriceAlert = PriceAlertInfo(
      name: name,
      high: high,
      low: low,
    );
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;
    await usersRef
        .child(uid)
        .child("priceAlerts")
        .push()
        .set(newPriceAlert.toJson());
    _priceAlerts.add(newPriceAlert);
    // usersRef.child(uid).update({"priceAlerts": _priceAlerts});

    for (InfoTile i in coinInfo) {
      for (PriceAlertInfo p in _priceAlerts) {
        if (i.name == p.name && coinNames.contains(i.name) == false) {
          coinNames.add(i.name);
          var low = p.low != null ? double.parse(p.low.replaceAll('%', '')) : 0;
          var high =
              p.high != null ? double.parse(p.high.replaceAll('%', '')) : 0;
          var percent = double.parse(i.changePercent.replaceAll('%', ''));
          if (percent != null) {
            if (percent > high) {
              await showNotification(i.name, "It's time to sell.", '$percent%');
            } else if (percent < low) {
              await showNotification(
                  i.name, "It's time to buy more.", '$percent%');
            } else if (percent > low && percent < high) {}
            dev.log(i.name);

            _priceAlertTiles.add(PriceAlertTileInfo(
              name: i.name,
              priceUsd: i.priceUsd,
              changePercent: i.changePercent,
              low: p.low,
              high: p.high,
              id: i.id,
              symbol: i.symbol,
            ));

            // log(i.changePercent);
          }
        }
      }
    }

    notifyListeners();
  }

  void removePriceAlert(String name) async {
    dev.log("remove caleed");
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;
    //remove entry which has name as bitcoin
    await usersRef
        .child(uid)
        .child("priceAlerts")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value["name"] == name) {
          usersRef.child(uid).child("priceAlerts").child(key).remove();
        }
      });
    });
    _isLoading = true;

    _getPriceAlerts();
    notifyListeners();
  }

  Future<void> showNotification(
      String title, String body, String notification) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        Random.secure().nextInt(1000) + 100,
        title,
        body,
        platformChannelSpecifics,
        payload: notification);
  }
}

class PriceAlertInfo {
  String low;
  String high;

  String name;

  PriceAlertInfo({
    this.low,
    this.high,
    this.name,
  });

  toJson() {
    return {
      "low": low,
      "high": high,
      "name": name,
    };
  }
}

class PriceAlertTileInfo {
  final String id, symbol, name, priceUsd, changePercent, high, low;
  PriceAlertTileInfo(
      {this.id,
      this.symbol,
      this.name,
      this.priceUsd,
      this.changePercent,
      this.high,
      this.low});
}

Widget PriceAlertTile(PriceAlertLogic priceAlertLogic, PriceAlertTileInfo info,
    BuildContext context) {
  var temp = double.parse(info.priceUsd) * 74.34;
  //p = temp.toStringAsFixed(2);

  var price = NumberFormat.simpleCurrency(locale: 'en_IN').format(temp);

  var temp1 = double.parse(info.changePercent);
  var changeP = temp1.toStringAsFixed(2);

  return GestureDetector(
    onLongPress: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Delete Alert"),
              content: Text("Are you sure you want to delete this alert?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    priceAlertLogic.removePriceAlert(info.name);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });

      // priceAlertLogic.removePriceAlert(info.name);
    },
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xFF29313C),
        borderRadius: BorderRadius.circular(10.0),
      ),
      //color: Colors.grey,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Image.asset(
                        "images/${info.id}.png",
                        errorBuilder: (context, e, stackTrace) {
                          return Icon(FontAwesomeIcons.coins);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.symbol,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          info.name,
                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !changeP.contains("-") ? "+$changeP%" : "$changeP%",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: temp1 > 0 ? Colors.red : Colors.green,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "High: ",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          info.high == null
                              ? Container()
                              : Text(
                                  info.high + "%",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Low:",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          info.low == null
                              ? Container()
                              : Text(
                                  info.low + "%",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
