import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Meal with ChangeNotifier {
  final String id;
  final String title;
  final String vegNonVeg;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Meal({
    @required this.id,
    @required this.title,
    @required this.vegNonVeg,
    @required this.category,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://canteen-app-9667c.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        notifyListeners();
        throw HttpException('Could not update Favorite Status');
      }
     
      // _setFavValue(oldStatus);
    
  }
}
