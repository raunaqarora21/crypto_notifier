import 'dart:developer';

import 'package:crypto_notifier/helper/news.dart';
import 'package:crypto_notifier/helper/subScribed_coins.dart';
import 'package:crypto_notifier/logics/article_view.dart';
import 'package:crypto_notifier/main.dart';
import 'package:crypto_notifier/models/article_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatefulWidget {
  final List coins;
  SubscriptionsScreen({this.coins});
  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Article> article = [];
  List<Article> articles = [];
  bool _loading = true;
  @override
  void initState() {
    getNews();
    super.initState();
  }

  List temp;
  List<String> subList = [];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future getData() async {
    // log("Get Data");
    // print(subList);

    // usersRef.child(uid).set({"subscriptions": subList});

    // log("Called");
    // log(uid.toString());
    News news = News();
    // temp = [];
    // final User user = _firebaseAuth.currentUser;
    // final uid = user.uid;

    // try {
    //   await usersRef.child(uid).child("subscriptions").once().then(
    //       (DataSnapshot snapshot) => snapshot.value.toString() != "null"
    //           ? temp.addAll(snapshot.value)
    //           : null);
    // } catch (e) {
    //   print(e);
    // }
    // subList = List<String>.from(temp);
    subList = Provider.of<AppData>(context, listen: false).subList;

    log("Here ksam");
    log(subList.toString());
    if (subList != null && subList.isNotEmpty && subList != []) {
      subList.forEach((element) async {
        print(element);
        await news.getNews(element);

        articles.addAll(news.news);
      });
    } else {
      _loading = false;
    }
  }

  getNews() async {
    // AppData appData = AppData();
    log(_loading.toString());
    setState(() {
      _loading = true;
    });
    await getData();
    setState(() {
      _loading = false;
    });
    log(_loading.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscriptions"),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: articles.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlogTile(
                      title: articles[index].title,
                      imageUrl: articles[index].urlToImage,
                      desc: articles[index].description,
                      url: articles[index].articleUrl,
                    );
                  },
                );
              },
            ),
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
