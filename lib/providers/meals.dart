import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _items = [];
  List<Meal> _starter = [];
  List<Meal> _mainCourse = [];
  List<Meal> _dessert = [];

  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Meals(this.authToken, this._items, this.userId);


  List<Meal> get items {
    _starter = [];
    _mainCourse = [];
    _dessert = [];
    _items.forEach((item) {
      if(item.category == 'Starters'){
        _starter.add(item);
      }
      else if(item.category == 'Main Course'){
        _mainCourse.add(item);
      }
      else if(item.category == 'Dessert'){
        _dessert.add(item);
      }
    });
    return [..._items];
  }

  //get starters
  List<Meal> get starters {
    return [..._starter]; 
  }

  //get main course
  List<Meal> get mainCourse {
    return [..._mainCourse];
  }

  //get dessert
  List<Meal> get dessert {
    return [..._dessert];
  }

  List<Meal> get favoriteItems {
    return _items.where((mealItem) => mealItem.isFavorite).toList();
  }

  //get favoriteStarter

  //get favoriteMainCourse

  //get favoriteDessert

  Meal findById(String mealId) {
    return _items.firstWhere((meal) => meal.id == mealId);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetMeal([bool filterByUser = false]) async {
    // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://canteen-app-9667c.firebaseio.com/meals.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Meal> loadedMeals = [];

      if (extractedData == null) {
        return;
      }

      url =
          'https://canteen-app-9667c.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((mealId, mealData) {
        loadedMeals.add(Meal(
          id: mealId,
          title: mealData['title'],
          vegNonVeg: mealData['vegNonVeg'],
          category: mealData['category'],
          description: mealData['description'],
          price: mealData['price'],
          imageUrl: mealData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[mealId] ?? false,
        ));
      });

      _items = loadedMeals;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addMeals(Meal meal) async {
    final url =
        'https://canteen-app-9667c.firebaseio.com/meals.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': meal.title,
          'description': meal.description,
          'vegNonVeg': meal.vegNonVeg,
          'category': meal.category,
          'imageUrl': meal.imageUrl,
          'price': meal.price,
          'creatorId': userId,
        }),
      );
      final newMeal = Meal(
        id: json.decode(response.body)['name'],
        title: meal.title,
        vegNonVeg: meal.vegNonVeg,
        category: meal.category,
        description: meal.description,
        price: meal.price,
        imageUrl: meal.imageUrl,
      );
      _items.add(newMeal);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateMeal(String id, Meal newMeal) async {
    final mealIndex = _items.indexWhere((meal) => meal.id == id);
    if (mealIndex >= 0) {
      final url =
          'https://canteen-app-9667c.firebaseio.com/meals/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': newMeal.title,
          'description': newMeal.description,
          'vegNonVeg': newMeal.vegNonVeg,
          'category': newMeal.category,
          'imageUrl': newMeal.imageUrl,
          'price': newMeal.price,
        }),
      );
      _items[mealIndex] = newMeal;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMeals(String id) async {
    final url =
        'https://canteen-app-9667c.firebaseio.com/meals/$id.json?auth=$authToken';
    final existingMealIndex = _items.indexWhere((meal) => meal.id == id);
    var existingMeal = _items[existingMealIndex];

    _items.removeAt(existingMealIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingMealIndex, existingMeal);
      notifyListeners();
      throw HttpException('Could not delete Meal');
    }
    existingMeal = null;
  }
}
