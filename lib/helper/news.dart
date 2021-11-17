import 'dart:convert';
import 'package:crypto_notifier/models/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<Article> news = [];
  Future<void> getNews(coinId) async {
    String url =
        "https://newsapi.org/v2/everything?q=$coinId&apiKey=acbe13a915184313924fa64727a66975";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}
