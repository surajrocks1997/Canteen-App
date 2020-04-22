import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_meals_screen.dart';
import '../providers/auth.dart';
import '../screens/analysis_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String emailId = Provider.of<Auth>(context).emailId;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(156, 39, 176, 1).withOpacity(0.4),
                  Color.fromRGBO(156, 39, 176, 1).withOpacity(1.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
              ),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Material(
                      child: CircleAvatar(
                        // backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                        radius: 40,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                      elevation: 15,
                    ),
                  ),
                  Text(
                    '$emailId',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Meals Categories'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Orders Assessment'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AnalysisScreen.routeName);
            },
          ),
          if (emailId == "admin@thisapp.com") Divider(),
          if (emailId == "admin@thisapp.com")
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Meals'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserMealsScreen.routeName);
              },
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
