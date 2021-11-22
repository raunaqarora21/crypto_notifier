import 'dart:convert';

import 'package:crypto_notifier/models/InfoTile.dart';

import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

//api key => d5910bb3-515e-429c-bc07-a12840da1705
class Data {
  List<InfoTile> list = [];
  Future<void> getData() async {
    String url = "https://api.coincap.io/v2/assets";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    jsonData["data"].forEach((element) {
      InfoTile infoTile = InfoTile(
        id: element["id"],
        symbol: element["symbol"],
        name: element["name"],
        priceUsd: element["priceUsd"],
        changePercent: element["changePercent24Hr"],
        marketCapUsd: element["marketCapUsd"],
      );

      list.add(infoTile);
    });
  }
}
