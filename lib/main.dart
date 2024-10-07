import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:belajarflutter1/halaman/splashscreen.dart';
import 'package:belajarflutter1/Models/AuthModel.dart';
import 'package:belajarflutter1/halaman/cart.dart';
import 'package:belajarflutter1/halaman/bottom-navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        home: SplashScreen(),
        routes: {
          '/navigasi': (context) => navigasi(),
          '/cart': (context) => Cart(token: Provider.of<UserModel>(context, listen: false).token),
        },
      ),
    );
  }
}








