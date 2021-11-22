import 'package:crypto_notifier/logics/priceAlertLogic.dart';
import 'package:crypto_notifier/screens/mainApp/priceAlert/addPriceAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class PriceAlert extends StatefulWidget {
  @override
  _PriceAlertState createState() => _PriceAlertState();
}

class _PriceAlertState extends State<PriceAlert> {
  FlutterLocalNotificationsPlugin flip;
  @override
  void initState() {
    // TODO: implement initState

    flip = FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PriceAlertLogic>(
        builder: (context, priceAlertLogic, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Price Alert'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPriceAlert(
                      priceAlertLogic: priceAlertLogic,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        body: priceAlertLogic.isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ))
            : ListView.builder(
                itemCount: priceAlertLogic.priceAlertTiles.length,
                itemBuilder: (context, index) {
                  return PriceAlertTile(priceAlertLogic,
                      priceAlertLogic.priceAlertTiles[index], context);
                },
              ),
      );
    });
  }
}
