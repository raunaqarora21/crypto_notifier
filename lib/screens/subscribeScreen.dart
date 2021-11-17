import 'dart:convert';

import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:crypto_notifier/components/subscribeButton.dart';
import 'package:crypto_notifier/helper/news.dart';
import 'package:crypto_notifier/helper/trianglePainter.dart';
import 'package:crypto_notifier/logics/article_view.dart';
import 'package:crypto_notifier/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'convertPage.dart';

class SubscribeScreen extends StatefulWidget {
  final String name;
  final String coinId;
  final String changePercent;
  final String price;
  final String symbol;
  SubscribeScreen(
      {this.name, this.coinId, this.price, this.changePercent, this.symbol});

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
  bool selected5 = false;
  bool viewMore = false;
  Color selectedColor = Color(0xFF222531);
  String url;
  List<Article> articles;
  @override
  void initState() {
    getChartsData();
    getNews();
    _trackballBehavior = TrackballBehavior(
        activationMode: ActivationMode.singleTap, enable: true);
    super.initState();
  }

  getChartsData() async {
    url =
        "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=d1";
    await getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    _chartData = [];

    jsonData["data"].forEach((element) {
      ChartData list = ChartData(
          x: DateTime.fromMillisecondsSinceEpoch(element["time"]),
          price: double.parse(element['priceUsd'].toString()));
      _chartData.add(list);
    });
    setState(() {
      _isLoading = false;
    });
  }

  getNews() async {
    setState(() {
      _isLoading = true;
    });
    articles = [];
    News news = News();
    await news.getNews(widget.coinId);
    articles = news.news;
    setState(() {
      _isLoading = false;
    });
  }

  getCustomData(int ch) {
    customList = [];
    switch (ch) {
      case 1:
        // Today
        var start =
            DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch;
        var end = DateTime.now().millisecondsSinceEpoch;
        url =
            "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=m1&start=$start&end=$end";
        getData();
        setState(() {
          // _isLoading = false;
        });
        // for (int i = 0; i < _chartData.length; i++) {
        //   if (_chartData[i].x.month == DateTime.now().month &&
        //       ((_chartData[i].x.day == DateTime.now().day))) {
        //     customList.add(_chartData[i]);
        //     // print(_chartData[i].x);
        //   }
        // }
        break;
      case 2:
        // 1 Day
        var start =
            DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch;
        var end = DateTime.now().millisecondsSinceEpoch;
        url =
            "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=m15&start=$start&end=$end";
        getData();
        setState(() {});

        break;
      case 3:
        // Week
        var start =
            DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;
        var end = DateTime.now().millisecondsSinceEpoch;
        url =
            "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=h1&start=$start&end=$end";
        getData();
        setState(() {});
        break;
      case 4:
        // 1 Month
        var start =
            DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch;
        var end = DateTime.now().millisecondsSinceEpoch;
        url =
            "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=h12&start=$start&end=$end";
        getData();
        setState(() {});

        break;
      case 5:
        // 1 Year
        var start =
            DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch;
        var end = DateTime.now().millisecondsSinceEpoch;
        url =
            "https://api.coincap.io/v2/assets/${widget.coinId}/history?interval=d1&start=$start&end=$end";
        getData();
        setState(() {});

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
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                widget.price,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      !widget.changePercent.contains("-")
                                          ? "+${widget.changePercent}%"
                                          : "${widget.changePercent}%",
                                      style: TextStyle(
                                          color: double.parse(
                                                      widget.changePercent) >
                                                  0
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  !widget.changePercent.contains("-")
                                      ? TriangleWidget(Colors.red)
                                      : RotatedBox(
                                          quarterTurns: 2,
                                          child: TriangleWidget(Colors.green),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40.0),
                          ),
                          color: Color(0xFF222531),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 25.0),
                              height: 400,
                              child: SfSparkLineChart.custom(
                                axisLineColor: Colors.transparent,
                                trackball: SparkChartTrackball(
                                    activationMode:
                                        SparkChartActivationMode.tap),
                                //Enable marker
                                color: widget.changePercent.contains("-")
                                    ? Colors.green
                                    : Colors.red,

                                //Enable data label
                                // labelDisplayMode: SparkChartLabelDisplayMode.all,
                                // labelDisplayMode: SparkChartLabelDisplayMode.high,
                                xValueMapper: (int index) =>
                                    _chartData[index].x,
                                yValueMapper: (int index) =>
                                    _chartData[index].price,

                                dataCount: _chartData.length,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10.0),
                              // color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected1 = true;
                                        selected2 = selected3 =
                                            selected5 = selected4 = false;
                                      });

                                      getCustomData(1);
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: selected1
                                            ? Colors.grey.shade500
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        "1H",
                                        style: TextStyle(
                                            color: selected1
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getCustomData(2);
                                      setState(() {
                                        selected2 = true;
                                        selected1 = selected3 =
                                            selected5 = selected4 = false;
                                      });
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: selected2
                                            ? Colors.grey.shade500
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        "1D",
                                        style: TextStyle(
                                            color: selected2
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getCustomData(3);
                                      setState(() {
                                        selected3 = true;
                                        selected5 = selected2 =
                                            selected1 = selected4 = false;
                                      });
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: selected3
                                            ? Colors.grey.shade500
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        "1W",
                                        style: TextStyle(
                                            color: selected3
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getCustomData(4);
                                      setState(() {
                                        selected4 = true;

                                        selected5 = selected2 =
                                            selected3 = selected1 = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: selected4
                                            ? Colors.grey.shade500
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        "1M",
                                        style: TextStyle(
                                            color: selected4
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getCustomData(5);
                                      setState(() {
                                        selected5 = true;

                                        selected4 = selected2 =
                                            selected3 = selected1 = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: selected5
                                            ? Colors.grey.shade500
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        "1Y",
                                        style: TextStyle(
                                            color: selected5
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConvertPage(
                                            price: widget.price,
                                            symbol: widget.symbol,
                                            id: widget.coinId,
                                          )),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                color: Color(0xFF343849),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Convert",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Support the conversion between two coins, \nwith fast trading",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ConvertCoin(),
                                          //   ),
                                          // );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "News",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 16.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: viewMore ? articles.length : 6,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    minVerticalPadding: 10.0,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ArticleView(
                                                    imageUrl: articles[index]
                                                        .articleUrl,
                                                  )));
                                    },
                                    leading: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            articles[index].urlToImage,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      articles[index].title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                            articles.length > 6
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        viewMore = !viewMore;
                                      });
                                    },
                                    child: Container(
                                        height: 50.0,
                                        padding: EdgeInsets.only(top: 10.0),
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Divider(color: Colors.white),
                                            Text(
                                              !viewMore
                                                  ? 'View More'
                                                  : 'View Less',
                                              style: TextStyle(
                                                  color: Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                            Divider(color: Colors.white),
                                          ],
                                        )),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class TriangleWidget extends StatelessWidget {
  final Color color;
  TriangleWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: TrianglePainter(
          strokeColor: this.color,
          strokeWidth: 10,
          paintingStyle: PaintingStyle.fill,
        ),
        child: Container(
          height: 8,
          width: 10,
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime x;
  final num price;

  ChartData({this.x, this.price});
}
