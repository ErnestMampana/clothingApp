import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavoratie;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavoratie = false});

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavoratie;
    isFavoratie = !isFavoratie;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-shop-57038-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavoratie,
          ));
      if (response.statusCode >= 400) {
        isFavoratie = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavoratie = oldStatus;
      notifyListeners();
    }
  }
}
