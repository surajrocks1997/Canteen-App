import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/meals.dart';
import './providers/orders.dart';
import './providers/profile.dart';

import './screens/meals_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_meals_screen.dart';
import './screens/edit_meals_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart.dart';
import './screens/profile_screen.dart';
import './screens/analysis_screen.dart';
import './screens/category_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Meals>(
            builder: (ctx, auth, previousMeals) => Meals(
                  auth.token,
                  previousMeals == null ? [] : previousMeals.items,
                  auth.userId,
                )),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, ProfileDetails>(
          builder: (ctx, auth, profileDetail) => ProfileDetails(
            profileDetail == null ? null : profileDetail.details,
            auth.token,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Canteen4U',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? CategoryScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            MealsOverviewScreen.routeName: (ctx) => MealsOverviewScreen(),
            MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserMealsScreen.routeName: (ctx) => UserMealsScreen(),
            EditMealScreen.routeName: (ctx) => EditMealScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            AnalysisScreen.routeName: (ctx) => AnalysisScreen(),
          },
        ),
      ),
    );
  }
}
