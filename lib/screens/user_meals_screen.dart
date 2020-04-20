import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/meals.dart';
import '../widgets/user_meal_item.dart';
import '../screens/edit_meals_screen.dart';

class UserMealsScreen extends StatelessWidget {
  static const routeName = '/user_meals';

  Future<void> _refreshMeals(BuildContext context) async {
    await Provider.of<Meals>(context, listen: false)
        .fetchAndSetMeal(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meals'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditMealScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshMeals(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshMeals(context),
                    child: Consumer<Meals>(
                      builder: (ctx, mealsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: <Widget>[
                              UserMealItem(
                                mealsData.items[index].id,
                                mealsData.items[index].title,
                                mealsData.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: mealsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
