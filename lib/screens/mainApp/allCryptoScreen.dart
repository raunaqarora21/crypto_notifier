import 'dart:developer';

import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/logics/priceAlertLogic.dart';
import 'package:crypto_notifier/models/CoinInfoTile.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:crypto_notifier/screens/mainApp/mainScreen.dart';
import 'package:crypto_notifier/screens/mainApp/priceAlert/priceAlert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_notifier/helper/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class AllCryptoScreen extends StatefulWidget {
  @override
  _AllCryptoScreenState createState() => _AllCryptoScreenState();
}

class _AllCryptoScreenState extends State<AllCryptoScreen> {
  List<InfoTile> coinInfo = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user;
  bool _loading;
  bool _priceAsc = false;
  bool _percAsc = false;
  String _sortBy = 'Sort By';
  String get sortBy => _sortBy;
  String name;

  set sortBy(String value) {
    setState(() {
      _sortBy = value;
    });
  }

  @override
  void initState() {
    user = _firebaseAuth.currentUser;
    getData();
    super.initState();
  }

  getData() async {
    Data info = Data();
    print(_loading);
    setState(() {
      _loading = true;
    });
    var res = await Future.wait<dynamic>([getName(user), info.getData()]);
    name = res[0];

    coinInfo = info.list;
    setState(() {
      _loading = false;
    });
    print(_loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: user.photoURL == null
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        name == null ? 'U' : name[0].toUpperCase(),
                        style: TextStyle(fontSize: 40),
                      ),
                    )
                  : NetworkImage(user.photoURL),
              accountName: name == null ? Text('User') : Text(name),
              accountEmail:
                  user.email == null ? Text('Email') : Text(user.email),
            ),
            ListTile(
              title: Text('All Coins'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCryptoScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Subscribed Coins'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider<AppData>(
                              create: (context) => AppData(),
                              child: MainScreen(),
                            )));
              },
            ),
            ListTile(
              title: Text('Price Alert'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<PriceAlertLogic>(
                            create: (context) => PriceAlertLogic(),
                            child: PriceAlert()),
                  ),
                );
              },
            ),
            // ListTile(
            //   title: Text('Settings'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   title: Text('About'),
            //   onTap: () {},
            // ),
            ListTile(
              title: Text('Contact Us'),
              onTap: () async {
                //open gmail  app
                //https://stackoverflow.com/questions/52724095/how-to-open-gmail-app-in-flutter
                await launch(emailLaunchUri.toString());
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              await _firebaseAuth.signOut();
                              Navigator.pushReplacementNamed(
                                  context, 'LoginScreen');
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });

                // _firebaseAuth.signOut();
                // Navigator.pushReplacementNamed(context, 'LoginScreen');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Crypto Notifer",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  getData();
                });
              },
              child: Container(
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Color(0xFF222531),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: false,
              primary: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        // color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(),
                            Container(),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    elevation: 10,
                                    backgroundColor: Color(0xFF1F2630),
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                          actions: [
                                            Container(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                color: Color(0xFF1F2630),
                                                child:
                                                    CupertinoActionSheetAction(
                                                  onPressed: () {},
                                                  child: Text("Sort By",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF727983),
                                                          fontSize: 16)),
                                                )),
                                            Container(
                                              color: Color(0xFF1F2630),
                                              child: CupertinoActionSheetAction(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Market Cap",
                                                          style: TextStyle(
                                                              color: sortBy ==
                                                                      "Market Cap"
                                                                  ? Colors.amber
                                                                  : Color(
                                                                      0xFF727983),
                                                              fontSize: 16)),
                                                      Icon(Icons.arrow_downward,
                                                          color: sortBy ==
                                                                  "Market Cap"
                                                              ? Colors.amber
                                                              : Color(
                                                                  0xFF727983),
                                                          size: 16)
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    coinInfo.sort((a, b) =>
                                                        double.parse(
                                                                b.marketCapUsd)
                                                            .toInt() -
                                                        double.parse(
                                                                a.marketCapUsd)
                                                            .toInt());
                                                    sortBy = "Market Cap";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xFF1F2630),
                                              child: CupertinoActionSheetAction(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Price",
                                                          style: TextStyle(
                                                              color: sortBy ==
                                                                      "Price"
                                                                  ? Colors.amber
                                                                  : Color(
                                                                      0xFF727983),
                                                              fontSize: 16)),
                                                      Icon(Icons.arrow_downward,
                                                          color: (sortBy ==
                                                                      "Price" &&
                                                                  _priceAsc ==
                                                                      true)
                                                              ? Colors.amber
                                                              : Color(
                                                                  0xFF727983),
                                                          size: 16),
                                                      Icon(Icons.arrow_upward,
                                                          color: (sortBy ==
                                                                      "Price" &&
                                                                  _priceAsc ==
                                                                      false)
                                                              ? Colors.amber
                                                              : Color(
                                                                  0xFF727983),
                                                          size: 16),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _priceAsc
                                                        ? coinInfo.sort((a,
                                                                b) =>
                                                            double.parse(
                                                                    a.priceUsd)
                                                                .toInt() -
                                                            double.parse(
                                                                    b.priceUsd)
                                                                .toInt())
                                                        : coinInfo.sort((a,
                                                                b) =>
                                                            double.parse(
                                                                    b.priceUsd)
                                                                .toInt() -
                                                            double.parse(
                                                                    a.priceUsd)
                                                                .toInt());
                                                    _priceAsc = !_priceAsc;
                                                    sortBy = "Price";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Container(
                                              color: Color(0xFF1F2630),
                                              child: CupertinoActionSheetAction(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("24H Change",
                                                          style: TextStyle(
                                                              color: sortBy ==
                                                                      "24H Change"
                                                                  ? Colors.amber
                                                                  : Color(
                                                                      0xFF727983),
                                                              fontSize: 16)),
                                                      Icon(Icons.arrow_downward,
                                                          color: (sortBy ==
                                                                      "24H Change" &&
                                                                  _percAsc ==
                                                                      true)
                                                              ? Colors.amber
                                                              : Color(
                                                                  0xFF727983),
                                                          size: 16),
                                                      Icon(Icons.arrow_upward,
                                                          color: (sortBy ==
                                                                      "24H Change" &&
                                                                  _percAsc ==
                                                                      false)
                                                              ? Colors.amber
                                                              : Color(
                                                                  0xFF727983),
                                                          size: 16),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _percAsc
                                                        ? coinInfo.sort((a,
                                                                b) =>
                                                            double.parse(a.changePercent)
                                                                .toInt() -
                                                            double.parse(b
                                                                    .changePercent)
                                                                .toInt())
                                                        : coinInfo.sort((a,
                                                                b) =>
                                                            double.parse(b
                                                                    .changePercent)
                                                                .toInt() -
                                                            double.parse(
                                                                    a.changePercent)
                                                                .toInt());
                                                    _percAsc = !_percAsc;
                                                    sortBy = "24H Change";
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                          cancelButton: Container(
                                            color: Color(0xFF1F2630),
                                            child: CupertinoActionSheetAction(
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Color(0xFF727983),
                                                      fontSize: 16)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF29313C),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        sortBy,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      sortBy == "Sort By"
                                          ? Container()
                                          : ((sortBy == "Price" &&
                                                      _priceAsc == false) ||
                                                  (sortBy == "24H Change" &&
                                                      _percAsc == false))
                                              ? Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.white,
                                                )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: coinInfo.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CoinInfoTile(
                          name: coinInfo[index].name,
                          symbol: coinInfo[index].symbol,
                          priceUsd: coinInfo[index].priceUsd,
                          id: coinInfo[index].id,
                          marketCapUsd: coinInfo[index].marketCapUsd,
                          changePercent: coinInfo[index].changePercent,
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
    );
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'contact@cryptonotifier.com',
    query: encodeQueryParameters(
        <String, String>{'subject': 'Feedback related to App'}),
  );
}

// ignore: missing_return
getName(user) async {
  //get name from firebase

  final uid = user.uid;
  String name;
  //   log(uid.toString());
  try {
    // log("Called here");
    name = await usersRef.child(uid).child("name").once().then(
        (DataSnapshot snapshot) => snapshot.value.toString() != "null"
            ? snapshot.value.toString()
            : null);
    return name;
  } catch (e) {
    log(e.toString());
  }
}

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
