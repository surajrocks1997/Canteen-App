import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/meal_item.dart';
import '../providers/meals.dart';
import '../providers/meal.dart';

class MealsGrid extends StatefulWidget {
  final bool showFavorites;
  final String category;

  MealsGrid(this.showFavorites, this.category);

  @override
  _MealsGridState createState() => _MealsGridState();
}

class _MealsGridState extends State<MealsGrid> {
  List<Meal> categoryMeals;

  @override
  void initState() {
    final mealsData = Provider.of<Meals>(context, listen: false);

    if (widget.category == "Starters") {
      categoryMeals =
          widget.showFavorites ? mealsData.favoriteItems : mealsData.starters;
    } else if (widget.category == "Main Course") {
      categoryMeals =
          widget.showFavorites ? mealsData.favoriteItems : mealsData.mainCourse;
    } else if (widget.category == "Dessert") {
      categoryMeals =
          widget.showFavorites ? mealsData.favoriteItems : mealsData.dessert;
    }
    // print(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: categoryMeals.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: categoryMeals[index],
          child: MealItem(),
        );
      },
    );
  }
}
