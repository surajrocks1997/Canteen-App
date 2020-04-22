import 'package:flutter/material.dart';
import './meals_overview_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchAndSetOrder().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MealsOverviewScreen.routeName,
                          arguments: "Starters",
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Image.asset('assets/images/starters.jpg'),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MealsOverviewScreen.routeName,
                          arguments: "Main Course",
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Image.asset('assets/images/mainCourse.jpg'),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          MealsOverviewScreen.routeName,
                          arguments: "Dessert",
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(20),
                        child: Image.asset('assets/images/dessert.jpg'),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
