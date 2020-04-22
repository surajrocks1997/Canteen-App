import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/meal_item.dart';
import '../providers/meals.dart';
import '../providers/meal.dart';

class MealsGrid extends StatelessWidget {
  final bool showFavorites;
  final String category;

  MealsGrid(this.showFavorites, this.category);

  @override
  Widget build(BuildContext context) {
    List<Meal> categoryMeals = [];
    Provider.of<Meals>(context, listen: false).items;

    if (category == "Starters") {
      categoryMeals = showFavorites
          ? Provider.of<Meals>(context, listen: false).favoriteItems
          : Provider.of<Meals>(context, listen: false).starters;
    } else if (category == "Main Course") {
      categoryMeals = showFavorites
          ? Provider.of<Meals>(context, listen: false).favoriteItems
          : Provider.of<Meals>(context, listen: false).mainCourse;
    } else if (category == "Dessert") {
      categoryMeals = showFavorites
          ? Provider.of<Meals>(context, listen: false).favoriteItems
          : Provider.of<Meals>(context, listen: false).dessert;
    }

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
