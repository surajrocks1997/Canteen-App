import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/meal_detail_screen.dart';
import '../providers/meal.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class MealItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<Meal>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              MealDetailScreen.routeName,
              arguments: meal.id,
            );
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/placeholder.jpg'),
            image: NetworkImage(meal.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Meal>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () async {
                try {
                  await Provider.of<Meal>(context, listen: false)
                      .toggleFavoriteStatus(
                    authData.token,
                    authData.userId,
                  );
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Favorite could not be updated',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            meal.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                  meal.id, meal.price, meal.title, meal.imageUrl);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item Added to Cart!',
                  ),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Undo?',
                    onPressed: () {
                      cart.removeSingleItem(meal.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
