import 'dart:convert';
import 'dart:developer';

import 'package:crypto_notifier/helper/news.dart';
import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:crypto_notifier/models/article_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AppData extends ChangeNotifier {
  bool _isLoading = true;
  List<InfoTile> _subCoins;
  List<Article> articles = [];
  List<String> subList = [];
  bool get isLoading => _isLoading;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<InfoTile> get subCoins => _subCoins;
  List temp;
  User user;
  News news;
  AppData() {
    log("App data called");
    loadData();
  }
  loadData() async {
    log("Called");

    _subCoins = [];
    user = _firebaseAuth.currentUser;
    news = News();
    _isLoading = true;
    notifyListeners();
    await getData2();
  }

  // getData() async {
  //   temp = [];
  //   articles = [];

  //   final uid = user.uid;
  //   log(uid.toString());
  //   try {
  //     // log("Called here");
  //     await usersRef.child(uid).child("subscriptions").once().then(
  //         (DataSnapshot snapshot) => snapshot.value.toString() != "null"
  //             ? temp.addAll(snapshot.value)
  //             : null);
  //   } catch (e) {
  //     print(e);
  //   }
  //   subList = List<String>.from(temp);

  //   // log("Here");
  //   // log(subList.toString());
  //   if (subList != null && subList.isNotEmpty && subList != []) {
  //     subList.forEach((element) async {
  //       // print(element);
  //       log(element.toString());
  //       await news.getNews(element);
  //       articles.addAll(news.news);
  //     });
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future getData2() async {
    temp = [];
    articles = [];
    final uid = user.uid;
    await usersRef.child(uid).child("subscriptions").once().then(
        (DataSnapshot snapshot) => snapshot.value.toString() != "null"
            ? temp.addAll(snapshot.value)
            : null);
    subList = List<String>.from(temp);
    log(subList.toString());
    Future.wait<void>(subList.map((element) async {
      await news.getNews(element);
      articles.addAll(news.news);
    })).then((value) {
      _isLoading = false;
      notifyListeners();
    });
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
    // subList = [];
    usersRef.child(uid).update({"subscriptions": subList});
    log("Removed");
    print(subList);

    notifyListeners();
  }
}
