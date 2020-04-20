import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_meals_screen.dart';
import '../providers/meals.dart';

class UserMealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserMealItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditMealScreen.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Meals>(context, listen: false)
                      .deleteMeals(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deletion Failed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
