import 'package:flutter/material.dart';
import './meals_overview_screen.dart';

import '../widgets/app_drawer.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed(MealsOverviewScreen.routeName);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                margin: EdgeInsets.all(20),
                child: Text(
                  'Starters',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: null,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                margin: EdgeInsets.all(20),
                child: Text(
                  'Main Course',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: null,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
                margin: EdgeInsets.all(20),
                child: Text(
                  'Dessert',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
          ],
        ));
  }
}
