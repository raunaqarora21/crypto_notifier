import 'package:crypto_notifier/logics/priceAlertLogic.dart';
import 'package:crypto_notifier/screens/addPriceAlert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceAlert extends StatefulWidget {
  @override
  _PriceAlertState createState() => _PriceAlertState();
}

class _PriceAlertState extends State<PriceAlert> {
  @override
  void initState() {
    // TODO: implement initState
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
                  return PriceAlertTile(
                    priceAlertLogic,
                    priceAlertLogic.priceAlertTiles[index],
                  );
                },
              ),
      );
    });
  }
}
