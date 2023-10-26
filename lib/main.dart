import 'package:flutter/material.dart';
import 'home_page.dart';
import 'coin_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // Pantalla primaria
        '/login': (context) =>
            CoinList(), // Pantalla secundaria (Formulario de inicio de sesión)
      },
    );
  }
}
