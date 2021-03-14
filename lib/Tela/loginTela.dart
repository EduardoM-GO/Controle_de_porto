import 'package:controle_barcos/widgets/loginform.dart';
import 'package:flutter/material.dart';

class loginTela extends StatefulWidget {
  @override
  _loginTelaState createState() => _loginTelaState();
}

class _loginTelaState extends State<loginTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: loginForm(),
    );
  }
}
