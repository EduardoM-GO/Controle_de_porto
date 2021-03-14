import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translator/translator.dart';
import 'package:controle_barcos/widgets/principalForm.dart';
import 'package:controle_barcos/widgets/funcao.dart';

class loginForm extends StatefulWidget {
  @override
  _loginFormState createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  final translator = GoogleTranslator();
  final _emailFocus = FocusNode();
  final _senhaFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _corPrincipal = Color(0xFF006876);
    final _corSegundaria = Colors.white;
    return Container(
      color: _corPrincipal,
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
          ),
          Text(
            'Controle de Porto',
            style: TextStyle(
                color: _corSegundaria,
                fontSize: 40,
                fontStyle: FontStyle.italic),
          ),
          Container(
            height: 50,
          ),
          Center(
            child: Card(
              color: _corSegundaria,
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            labelStyle: TextStyle(color: _corPrincipal),
                          ),
                          controller: _email,
                          style: TextStyle(color: _corPrincipal),
                          focusNode: _emailFocus,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: _corPrincipal),
                          ),
                          controller: _senha,
                          style: TextStyle(
                              color: _corPrincipal,
                              decorationColor: _corPrincipal),
                          focusNode: _senhaFocus,
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          child: Container(
                            width: 70,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Icon(Icons.login),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Entrar',
                                    style: TextStyle(color: _corSegundaria),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            int i = 0;

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _email.text,
                                      password: _senha.text);
                            } on FirebaseAuthException catch (e) {
                              translator.translate(e.code, to: 'pt').then(
                                  (result) =>
                                      aviso(context, 'Erro', result.text));
                              i = 1;
                            }

                            if (i == 0) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          principalForm(_email.text)));
                              await FirebaseAuth.instance.signOut();
                              _email.clear();
                              _senha.clear();
                            }
                            _emailFocus.requestFocus();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: _corPrincipal, // background
                            onPrimary: _corSegundaria, // foreground
                          ),
                        ),
                        /*TextButton(
                    child: Text('Criar uma nova conta?'),
                    onPressed: () async {
                      int i = 0;
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        translator.translate(e.code, to: 'pt').then((result) =>
                            _showDialog(context, 'Erro', result.text));
                        i = 1;
                      }
                      if (i == 0) {
                        _showDialog(context, 'Aviso', "Registrou!");
                      }
                      print("Conex");
                    },
                    style: TextButton.styleFrom(
                      primary: _corPrincipal,
                    ),
                  ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
