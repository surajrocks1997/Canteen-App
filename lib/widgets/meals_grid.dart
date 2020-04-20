import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/meal_item.dart';
import '../providers/meals.dart';

class MealsGrid extends StatelessWidget {

  final bool showFavorites;

  MealsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final mealsData = Provider.of<Meals>(context);
    final meals = showFavorites ? mealsData.favoriteItems : mealsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: meals.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: meals[index],
          child: MealItem(
          
          ),
        );
      },
    );
  }
}
