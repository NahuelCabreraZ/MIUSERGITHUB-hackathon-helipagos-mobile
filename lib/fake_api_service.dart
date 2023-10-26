import 'dart:convert';
import 'cards_news_model.dart';
import 'package:flutter/services.dart';

class DataService {
  Future<List<CardNewsInfo>> fetchDataFromJson() async {
    final String jsonString = await rootBundle.loadString('/fake_news.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<CardNewsInfo> newsCards = [];

    for (var jsonData in jsonList) {
      final infoCard = CardNewsInfo(
          title: jsonData['title'],
          description: jsonData['description'],
          imageUrl: jsonData['imageUrl'],
          likes: jsonData['likes']);
      newsCards.add(infoCard);
    }

    return newsCards;
  }
}
