import 'package:assignmentapp/screens/cartview.dart';
import 'package:assignmentapp/screens/homepage.dart';
import 'package:flutter/material.dart';

import 'screens/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/homepage': (context) => const HomePage(),
        '/cartpage': (context) => const CartPage()
      },
    );
  }
}
