import 'package:flutter/material.dart';
import 'package:rick_morty_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

//pubspect y agregar la siguiente dependencia
//infiniti scroll pagination
//pubspec.yaml revisar aqui

//pub.dev/packages/infinite_scroll_pagination/example