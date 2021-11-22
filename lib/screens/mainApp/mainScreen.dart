import 'dart:developer';

import 'package:crypto_notifier/components/RoundButton.dart';
import 'package:crypto_notifier/logics/article_view.dart';
import 'package:crypto_notifier/logics/priceAlertLogic.dart';

import 'package:crypto_notifier/models/CoinInfoTile.dart';

import 'package:crypto_notifier/screens/mainApp/allCryptoScreen.dart';
import 'package:crypto_notifier/screens/mainApp/priceAlert/priceAlert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:workmanager/workmanager.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        return Scaffold(
            appBar: AppBar(title: Text('Your Subsriptions')),
            body: appData.isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListView.builder(
                            itemCount: appData.subList.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return subsribeTile(
                                  appData.subList[index], appData);
                            }),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: appData.articles.length,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BlogTile(
                              title: appData.articles[index].title,
                              imageUrl: appData.articles[index].urlToImage,
                              desc: appData.articles[index].description,
                              url: appData.articles[index].articleUrl,
                            );
                          },
                        )
                      ],
                    ),
                  ));
      },
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({this.imageUrl, this.title, this.desc, this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      imageUrl: url,
                    )));
      },
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(imageUrl)),
              SizedBox(
                height: 8.0,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                desc,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget subsribeTile(String name, AppData appData) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0xFF29313C),
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.all(20.0),
    margin: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  CircleAvatar(
                    child: Image.asset(
                      "images/$name.png",
                      errorBuilder: (context, e, stackTrace) {
                        return Icon(FontAwesomeIcons.coins);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                appData.deleteSub("coinName", name);
              },
            ),
          ],
        )
      ],
    ),
  );
}
