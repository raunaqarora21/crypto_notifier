import 'dart:developer';

import 'package:crypto_notifier/components/RoundButton.dart';

import 'package:crypto_notifier/models/CoinInfoTile.dart';

import 'package:crypto_notifier/screens/allCryptoScreen.dart';
import 'package:crypto_notifier/screens/priceAlert.dart';
import 'package:crypto_notifier/screens/subscriptionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:workmanager/workmanager.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'C',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              accountName: Text('Crypto Notifier'),
              accountEmail: Text('@crypto_notifier'),
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
                    builder: (context) => SubscriptionsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Price Alert'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceAlert(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              title: Text('About'),
              onTap: () {},
            ),
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
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('CryptoWatch')),
      body: context.watch<AppData>().isLoading
          ? Center(child: CircularProgressIndicator())
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
                                      builder: (context) =>
                                          // SubscriptionsScreen(
                                          //       coins: context
                                          //           .watch<AppData>()
                                          //           .subCoins,
                                          //     )
                                          AllCryptoScreen()));
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<AppData>(context, listen: false)
                              .loadData();
                          Workmanager().registerOneOffTask(
                            "1",
                            "simplePeriodic1HourTask",
                            inputData: <String, dynamic>{
                              'int': 1,
                              'bool': true,
                              'double': 1.0,
                              'string': 'string',
                              'array': [1, 2, 3],
                            },
                          );
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

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'contact@cryptonotifier.com',
    query: encodeQueryParameters(
        <String, String>{'subject': 'Example Subject & Symbols are allowed!'}),
  );
}

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
