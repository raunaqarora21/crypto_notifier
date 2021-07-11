import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:crypto_notifier/components/subscribeButton.dart';
import 'package:flutter/material.dart';
class SubscribeScreen extends StatefulWidget {
  final String name;
  final String coinId;
  SubscribeScreen({this.name,this.coinId});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white
                ),
              ),
              SubscribeButton(coinName: widget.name,coinId: widget.coinId,),
            ],
          ),
        ),
      ),
    );
  }
}
