import 'dart:developer';

import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:crypto_notifier/logics/priceAlertLogic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPriceAlert extends StatefulWidget {
  PriceAlertLogic priceAlertLogic;
  AddPriceAlert({this.priceAlertLogic});
  @override
  _AddPriceAlertState createState() => _AddPriceAlertState();
}

class _AddPriceAlertState extends State<AddPriceAlert> {
  var selectedCurrency = "Select CryptoCurrency";
  var high, low;
  var id;
  var icon;
  TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Price Alert'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              GestureDetector(
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
                            itemCount: widget.priceAlertLogic.coinInfo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 13,
                                  child: Image.asset(
                                    "images/${widget.priceAlertLogic.coinInfo[index].id}.png",
                                    errorBuilder: (context, e, stackTrace) {
                                      return Icon(FontAwesomeIcons.coins);
                                    },
                                  ),
                                ),
                                title: Container(
                                  child: Row(
                                    children: [
                                      Text(
                                          widget.priceAlertLogic.coinInfo[index]
                                              .symbol,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                          "(" +
                                              widget.priceAlertLogic
                                                  .coinInfo[index].name +
                                              ")",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          )),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedCurrency = widget
                                        .priceAlertLogic.coinInfo[index].name;
                                    _controller.text = selectedCurrency;
                                    // widget.symbol = value;
                                    id = widget
                                        .priceAlertLogic.coinInfo[index].id;
                                    icon = CircleAvatar(
                                      radius: 20,
                                      child: Image.asset(
                                        "images/${id}.png",
                                        errorBuilder: (context, e, stackTrace) {
                                          return Icon(FontAwesomeIcons.coins);
                                        },
                                      ),
                                    );
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
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      color: Color(0xFF29313C),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Select Cryptocurrency',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: icon == null
                              ? Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.amber,
                                )
                              : icon),
                      enabled: false,
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF29313C),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // keyboard: TextInputType.number,
                    border: InputBorder.none,
                    labelText: 'Low',
                    labelStyle: TextStyle(color: Colors.white),
                    icon: Icon(Icons.arrow_downward, color: Colors.amber),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                  onChanged: (value) {
                    low = value;
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF29313C),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                padding: EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  decoration: InputDecoration(
                    labelText: 'High',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Colors.amber,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                  onChanged: (value) {
                    high = value;
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              RoundButton(
                title: 'Add Price Alert',
                onPress: () {
                  log("Clicked..");
                  if (check(high, low, selectedCurrency, context)) {
                    widget.priceAlertLogic
                        .addPriceAlert(selectedCurrency, high, low);
                    Navigator.pop(context);
                  }
                },
                color: Colors.amber,
              )
            ],
          ),
        ));
  }
}

// ignore: missing_return
bool check(high, low, String selectedCurrency, BuildContext context) {
  if (high == null ||
      low == null ||
      selectedCurrency == "Select CryptoCurrency") {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please fill all the fields"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
    return false;
  } else {
    if (double.parse(high) < double.parse(low)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Low cannot be higher than High"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return false;
    }
    return true;
  }
}
