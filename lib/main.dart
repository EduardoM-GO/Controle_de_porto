import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:controle_barcos/Tela/loginTela.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Controle",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity,
        popupMenuTheme:PopupMenuThemeData(
          color: Colors.white
        )
       ),
      home: loginTela(),
    );
  }
}
