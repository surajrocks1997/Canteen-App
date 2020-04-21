import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/meals_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart.dart';
import '../providers/meals.dart';
import '../providers/profile.dart';
import '../providers/orders.dart';

enum FilterOptions {
  Favorites,
  All,
}

class MealsOverviewScreen extends StatefulWidget {
  static const routeName = '/meals-overview';
  @override
  _MealsOverviewScreenState createState() => _MealsOverviewScreenState();
}

class _MealsOverviewScreenState extends State<MealsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  String category;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      category = ModalRoute.of(context).settings.arguments as String;
      // print(category);
      setState(() {
        _isLoading = true;
      });
      Provider.of<Meals>(context).fetchAndSetMeal().then((_) {
        setState(() {
          _isLoading = false;
        },);
      });
    }
    Provider.of<ProfileDetails>(context).fetchAndSetProfile();
    Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : MealsGrid(_showOnlyFavorites, category),
    );
  }
}
