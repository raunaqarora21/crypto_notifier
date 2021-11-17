import 'package:crypto_notifier/screens/mainScreen.dart';
import 'package:crypto_notifier/screens/subscribeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CoinInfoTile extends StatelessWidget {
  final String id, symbol, name, marketCapUsd, priceUsd, changePercent;
  CoinInfoTile(
      {this.id,
      this.symbol,
      this.priceUsd,
      this.marketCapUsd,
      this.name,
      this.changePercent});

  double temp;
  String price;
  String p;
  double temp1;
  String changeP;

  @override
  Widget build(BuildContext context) {
    temp = double.parse(priceUsd) * 74.40;
    //p = temp.toStringAsFixed(2);

    price = NumberFormat.simpleCurrency(locale: 'en_IN').format(temp);

    temp1 = double.parse(changePercent);
    changeP = temp1.toStringAsFixed(2);
    return GestureDetector(
      onTap: () async {
        print(name);
        await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SubscribeScreen(
                      name: name,
                      coinId: id,
                      price: price,
                      changePercent: changeP,
                      symbol: symbol,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF222531),
            borderRadius: BorderRadius.circular(10.0),
          ),
          //color: Colors.grey,
          padding: EdgeInsets.all(15.0),
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
                          child: Image.asset("images/$id.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              symbol,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              name,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 10.0),
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
                                !changeP.contains("-")
                                    ? "+$changeP%"
                                    : "$changeP%",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color:
                                        temp1 > 0 ? Colors.red : Colors.green,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
