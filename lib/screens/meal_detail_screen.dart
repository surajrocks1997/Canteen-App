import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final loadedMeal =
        Provider.of<Meals>(context, listen: false).findById(mealId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedMeal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: loadedMeal.id,
                child: Image.network(
                  loadedMeal.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'INR ${loadedMeal.price}',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                '${loadedMeal.description}',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            (loadedMeal.vegNonVeg == "Veg")
                ? Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/images/Veg.jpg'),
                  )
                : Container(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/images/NonVeg.jpg'),
                  )
          ],
        ),
      ),
    );
  }
}
