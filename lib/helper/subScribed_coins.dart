import 'dart:convert';
import 'dart:developer';

import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AppData with ChangeNotifier {
  bool _isLoading = false;
  List<InfoTile> _subCoins;
  List<String> subList = [];
  bool get isLoading => _isLoading;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<InfoTile> get subCoins => _subCoins;
  List temp;
  AppData() {
    log("App data called");
    loadData();
  }
  loadData() async {
    log("Called");

    _subCoins = [];
    _isLoading = true;
    notifyListeners();
    await getData();
    notifyListeners();
  }

  getData() async {
    // log("Get Data");
    // print(subList);

    // usersRef.child(uid).set({"subscriptions": subList});

    // log("Called");
    // log(uid.toString());
    temp = [];
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;
    log(uid.toString());
    try {
      log("Called here");
      await usersRef.child(uid).child("subscriptions").once().then(
          (DataSnapshot snapshot) => snapshot.value.toString() != "null"
              ? temp.addAll(snapshot.value)
              : null);
    } catch (e) {
      print(e);
    }
    subList = List<String>.from(temp);

    log("Here");
    log(subList.toString());
    if (subList != null && subList.isNotEmpty && subList != []) {
      subList.forEach((element) async {
        print(element);
        await getCoinData(element);
      });
    } else {
      _isLoading = false;
    }
  }

  Future<void> getCoinData(String coinId) async {
    String url = "https://api.coincap.io/v2/assets/$coinId";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      _isLoading = false;
      notifyListeners();
    }
    var jsonData = jsonDecode(response.body);

    _subCoins.add(
      InfoTile(
        id: jsonData["data"]["id"],
        symbol: jsonData["data"]["symbol"],
        name: jsonData["data"]["name"],
        priceUsd: jsonData["data"]["priceUsd"],
        marketCapUsd: jsonData["data"]["marketCapUsd "],
        changePercent: jsonData["data"]["changePercent24Hr"],
      ),
    );
    _isLoading = false;
    notifyListeners();
  }

  void addtoSub(coinName, coinId) {
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;
    print("CoinId: " + coinId);
    subList.add(coinId);
    usersRef.child(uid).update({"subscriptions": subList});
    log("Added");
    print(subList);
    notifyListeners();
  }

  void deleteSub(coinName, coinId) {
    final User user = _firebaseAuth.currentUser;
    final uid = user.uid;

    subList.remove(coinId);
    usersRef.child(uid).update({"subscriptions": subList});
    log("Removed");
    print(subList);
    notifyListeners();
  }
}
