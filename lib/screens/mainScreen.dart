import 'dart:developer';

import 'package:crypto_notifier/components/RoundButton.dart';

import 'package:crypto_notifier/models/CoinInfoTile.dart';

import 'package:crypto_notifier/screens/allCryptoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_notifier/helper/subScribed_coins.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CryptoWatch')),
      body: context.watch<AppData>().isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: RoundButton(
                            title: 'View All CryptoCurrencies',
                            color: Colors.yellow,
                            onPress: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => AllCryptoScreen()));
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<AppData>(context, listen: false)
                              .loadData();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                      itemCount: context.watch<AppData>().subCoins.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CoinInfoTile(
                          id: context.watch<AppData>().subCoins[index].id,
                          name: context.watch<AppData>().subCoins[index].name,
                          priceUsd:
                              context.watch<AppData>().subCoins[index].priceUsd,
                          symbol:
                              context.watch<AppData>().subCoins[index].symbol,
                          marketCapUsd: context
                              .watch<AppData>()
                              .subCoins[index]
                              .marketCapUsd,
                          changePercent: context
                              .watch<AppData>()
                              .subCoins[index]
                              .changePercent,
                        );
                      })
                ],
              ),
            ),
    );
  }
}
