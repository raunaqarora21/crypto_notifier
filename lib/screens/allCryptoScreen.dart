import 'package:crypto_notifier/models/CoinInfoTile.dart';
import 'package:crypto_notifier/models/InfoTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crypto_notifier/helper/data.dart';

class AllCryptoScreen extends StatefulWidget {
  @override
  _AllCryptoScreenState createState() => _AllCryptoScreenState();
}

class _AllCryptoScreenState extends State<AllCryptoScreen> {
  List<InfoTile> coinInfo = [];
  bool _loading;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    Data info = Data();
    print(_loading);
    setState(() {
      _loading = true;
    });
    await info.getData();
    coinInfo = info.list;
    setState(() {
      _loading = false;
    });
    print(_loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All CryptoCurrencies",
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
                            Container(
                                // decoration: BoxDecoration(
                                //     //color: Color(0xFF222531),
                                //     borderRadius: BorderRadius.circular(5.0)),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 15.0, vertical: 10.0),
                                // child: Text(
                                //   "Market Cap",
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                // )
                                ),
                            Container(
                                // decoration: BoxDecoration(
                                //     //color: Color(0xFF222531),
                                //     borderRadius: BorderRadius.circular(5.0)),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 15.0, vertical: 10.0),
                                // child: Text(
                                //   "Price",
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                // )
                                ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(15.0)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Text(
                                  "Change%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
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
}
