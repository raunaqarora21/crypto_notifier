import 'dart:developer';

import 'package:crypto_notifier/helper/data.dart';
import 'package:flutter/material.dart';

import 'allCryptoScreen.dart';

class ConvertPage extends StatefulWidget {
  final String price;
  final String symbol;
  String id;
  ConvertPage({this.symbol, this.id, this.price});

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  Data data;
  List currencies;
  bool loading = true;
  String price;
  var actualPrice;
  var numOfCoins = 1;
  var coinPrice;
  TextEditingController _toController;
  @override
  void initState() {
    data = Data();
    _toController = TextEditingController();
    formList();
    // calculate();
    super.initState();
  }

  formList() async {
    setState(() {
      loading = true;
    });
    await data.getData();
    currencies = data.list;
    for (int i = 0; i < currencies.length; i++) {
      if (currencies[i].id == widget.id) {
        coinPrice = currencies[i].priceUsd;
      }
    }
    price = data.list[0].priceUsd;
    actualPrice = double.parse(price);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Convert'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Text(
                            "From",
                            style: TextStyle(
                              color: Color(0xFF78808B),
                              fontSize: 16,
                            ),
                          )),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF29313C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              children: [
                                DropDownWidget(
                                  symbol: widget.symbol,
                                  id: widget.id,
                                  currencies: currencies,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    enabled: true,
                                    // focusNode: FocusNode(),
                                    initialValue: numOfCoins.toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        numOfCoins =
                                            double.parse(value).toInt();
                                        _toController.text =
                                            ((double.parse(coinPrice) *
                                                        numOfCoins) /
                                                    actualPrice)
                                                .toString();
                                      });
                                    },
                                    cursorColor: Colors.amber,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Amount',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Text(
                            "To",
                            style: TextStyle(
                              color: Color(0xFF78808B),
                              fontSize: 16,
                            ),
                          )),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF29313C),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              children: [
                                DropDownWidget2(
                                  symbol: "BTC",
                                  id: "bitcoin",
                                  fromCoinPrice: double.parse(coinPrice),
                                  currencies: currencies,
                                  controller: _toController,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    controller: _toController,
                                    enabled: false,
                                    focusNode: FocusNode(),
                                    cursorColor: Colors.amber,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )));
  }
}

class DropDownWidget extends StatefulWidget {
  String symbol;
  String id;
  List currencies;
  TextEditingController controller;
  DropDownWidget({this.symbol, this.id, this.currencies, this.controller});
  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String value;
  String id;
  String initialValue;
  var selectedCoinPrice;
  initState() {
    value = widget.symbol;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //     });
      },
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            CircleAvatar(
              radius: 13,
              child: Image.asset("images/$id.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            VerticalDivider(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownWidget2 extends StatefulWidget {
  String symbol;
  String id;
  List currencies;
  TextEditingController controller;
  double fromCoinPrice;
  DropDownWidget2(
      {this.symbol,
      this.id,
      this.currencies,
      this.controller,
      this.fromCoinPrice});
  @override
  _DropDownWidgetState2 createState() => _DropDownWidgetState2();
}

class _DropDownWidgetState2 extends State<DropDownWidget2> {
  String value;
  String id;
  String initialValue;
  var selectedCoinPrice;
  initState() {
    value = widget.symbol;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            backgroundColor: Color(0xFF3C424E),
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.currencies.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 13,
                        child: Image.asset(
                            "images/${widget.currencies[index].id}.png"),
                      ),
                      title: Container(
                        child: Row(
                          children: [
                            Text(widget.currencies[index].symbol,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("(" + widget.currencies[index].name + ")",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                )),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          value = widget.currencies[index].symbol;
                          widget.symbol = value;
                          id = widget.currencies[index].id;
                          for (int i = 0; i < widget.currencies.length; i++) {
                            if (widget.currencies[i].id == id) {
                              selectedCoinPrice =
                                  double.parse(widget.currencies[i].priceUsd);
                            }
                          }
                          widget.controller.text =
                              (widget.fromCoinPrice / selectedCoinPrice)
                                  .toStringAsFixed(5);
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              );
            });
      },
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            CircleAvatar(
              radius: 13,
              child: Image.asset("images/$id.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            VerticalDivider(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
