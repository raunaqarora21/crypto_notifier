import 'dart:convert';

import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:crypto_notifier/components/subscribeButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SubscribeScreen extends StatefulWidget {
  final String name;
  final String coinId;
  final String price;
  SubscribeScreen({this.name, this.coinId, this.price});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool _isLoading;
  List<ChartData> customList;
  List<ChartData> _chartData;
  TrackballBehavior _trackballBehavior;
  bool selected4 = false;
  bool selected1 = false;
  bool selected2 = false;
  bool selected3 = false;
  @override
  void initState() {
    getChartsData();
    _trackballBehavior = TrackballBehavior(
        activationMode: ActivationMode.singleTap, enable: true);
    super.initState();
  }

  getChartsData() async {
    setState(() {
      _isLoading = true;
    });
    await getData();
    setState(() {
      _isLoading = false;
    });
  }

  getData() async {
    String url =
        "https://api.coincap.io/v2/candles?exchange=poloniex&interval=h8&baseId=ethereum&quoteId=bitcoin";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    _chartData = [];

    jsonData["data"].forEach((element) {
      ChartData list = ChartData(
        x: DateTime.fromMillisecondsSinceEpoch(element["period"]),
        open: double.parse(element['open']),
        close: double.parse(element["close"]),
        low: double.parse(element["low"]),
        high: double.parse(element["high"]),
      );
      _chartData.add(list);
    });
  }

  reDraw(List<ChartData> list) async {
    setState(() {
      _isLoading = true;
    });
    await getData();
    setState(() {
      _isLoading = false;
    });
  }

  getCustomData(int ch) {
    customList = [];
    switch (ch) {
      case 1:
        // Today
        for (int i = 0; i < _chartData.length; i++) {
          if (_chartData[i].x.month == DateTime.now().month &&
              ((_chartData[i].x.day == DateTime.now().day))) {
            customList.add(_chartData[i]);
            // print(_chartData[i].x);
          }
        }
        break;
      case 2:
        // This Month
        for (int i = 0; i < _chartData.length; i++) {
          if (_chartData[i].x.month == DateTime.now().month) {
            customList.add(_chartData[i]);
            // print(_chartData[i].x);
          }
        }
        break;
      case 3:
        // Last Month
        for (int i = 0; i < _chartData.length; i++) {
          if (_chartData[i].x.month >= DateTime.now().month - 1) {
            customList.add(_chartData[i]);
            // print(_chartData[i].x);
          }
        }
        break;
      case 4:
        // Last 6 Months
        for (int i = 0; i < _chartData.length; i++) {
          if (_chartData[i].x.month >= DateTime.now().month - 6) {
            customList.add(_chartData[i]);
            // print(_chartData[i].x);
          }
        }
        break;
      default:
    }

    setState(() {});

    // print(DateTime.fromMillisecondsSinceEpoch(1633190400000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        actions: [
          SubscribeButton(
            coinName: widget.name,
            coinId: widget.coinId,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        widget.price,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    Container(
                      height: 500,
                      child: SfCartesianChart(
                        zoomPanBehavior: ZoomPanBehavior(
                            enablePinching: true, enablePanning: true),
                        series: <CandleSeries>[
                          CandleSeries<ChartData, DateTime>(
                              dataSource: customList,
                              xValueMapper: (ChartData sales, _) => sales.x,
                              lowValueMapper: (ChartData sales, _) => sales.low,
                              highValueMapper: (ChartData sales, _) =>
                                  sales.high,
                              openValueMapper: (ChartData sales, _) =>
                                  sales.open,
                              closeValueMapper: (ChartData sales, _) =>
                                  sales.close)
                        ],
                        primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.MMM(),
                            majorGridLines: MajorGridLines(width: 0)),
                        enableAxisAnimation: true,
                        primaryYAxis: NumericAxis(
                            majorGridLines: MajorGridLines(width: 0)),
                        trackballBehavior: _trackballBehavior,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10.0),
                      // color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected1 = true;
                                selected2 = selected3 = selected4 = false;
                              });

                              getCustomData(1);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selected1
                                    ? Colors.grey.shade500
                                    : Colors.white,
                              ),
                              child: Text(
                                "24 Hr",
                                style: TextStyle(
                                    color: selected1
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getCustomData(2);
                              setState(() {
                                selected2 = true;
                                selected1 = selected3 = selected4 = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selected2
                                    ? Colors.grey.shade500
                                    : Colors.white,
                              ),
                              child: Text(
                                "This Month",
                                style: TextStyle(
                                    color: selected2
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getCustomData(3);
                              setState(() {
                                selected3 = true;
                                selected2 = selected1 = selected4 = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selected3
                                    ? Colors.grey.shade500
                                    : Colors.white,
                              ),
                              child: Text(
                                "Last Month",
                                style: TextStyle(
                                    color: selected3
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              getCustomData(4);
                              setState(() {
                                selected4 = true;

                                selected2 = selected3 = selected1 = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: selected4
                                    ? Colors.grey.shade500
                                    : Colors.white,
                              ),
                              child: Text(
                                "Last 6 Months",
                                style: TextStyle(
                                    color: selected4
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class ChartData {
  final DateTime x;
  final num open;
  final num close;
  final num low;
  final num high;

  ChartData({this.x, this.open, this.close, this.low, this.high});
}
