import 'dart:convert';
import 'dart:developer';

import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {
  bool _isLoading = false;
  List<InfoTile> _subCoins;
  List<String> subList = [];
  bool get isLoading => _isLoading;

  List<InfoTile> get subCoins => _subCoins;
  AppData() {
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
    log("Get Data");
    print(subList);
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
    print("CoinId: " + coinId);
    subList.add(coinId);
    log("Added");
    print(subList);
    notifyListeners();
  }

  void deleteSub(coinName, coinId) {
    subList.remove(coinId);
    log("Removed");
    print(subList);
    notifyListeners();
  }
}
