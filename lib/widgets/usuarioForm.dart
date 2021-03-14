import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_barcos/widgets/funcao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class usuariosForm extends StatefulWidget {
  final documents;
  final email;

  usuariosForm({this.documents, this.email});

  @override
  _usuarriosFormState createState() => _usuarriosFormState();
}

enum _cargo { Capitao, Administrativo }

class _usuarriosFormState extends State<usuariosForm> {
  final _corPrincipal = Color(0xFF006876);
  final _corSegundaria = Colors.white;

  _cargo _cargoControle = _cargo.Capitao;
  TextEditingController _nome = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  final _translator = GoogleTranslator();
  int _emailSalvo = 0;

  /*@override
  void initState() {
    super.initState();
    if (widget.documents == null) {
      _nome.text = "";
      _email.text = "";
      _senha.text = "";
      controleStatus = true;
    } else {
      _nome.text = widget.documents["Nome"];
      _email.text = widget.email;
      _senha.text = "123456789";
      controleStatus = false;
      if (widget.documents["Tipo"] == "Capitao") {
        _cargoControle = _cargo.Capitao;
      } else {
        _cargoControle = _cargo.Administrativo;
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: _corPrincipal,
                expandedHeight: 150.0,
                flexibleSpace: const FlexibleSpaceBar(
                  background: FlutterLogo(),
                  title: Text('Cadastro de Usuário'),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save, color: _corSegundaria),
                    tooltip: 'Salvar Usuário',
                    onPressed: () async {
                      if (_emailSalvo == 0) {
                        _emailSalvo = 1;
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email.text, password: _senha.text);
                        } on FirebaseAuthException catch (e) {
                          _translator.translate(e.code, to: 'pt').then(
                              (result) =>
                                  _showDialog(context, 'Erro', result.text));
                          _emailSalvo = 0;
                        }
                      } else if (_senha.text.isEmpty == false) {
                        try {
                          await FirebaseAuth.instance
                              .confirmPasswordReset(newPassword: _senha.text);
                        } on FirebaseAuthException catch (e) {
                          _translator.translate(e.code, to: 'pt').then(
                              (result) =>
                                  _showDialog(context, 'Erro', result.text));
                          _emailSalvo = 0;
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection("Usuario")
                          .doc(_email.text)
                          .set({
                        "Nome": _nome.text,
                        "Tipo": _cargoControle
                            .toString()
                            .substring(7, _cargoControle.toString().length)
                      });
                      Navigator.pop(
                        context,
                      );
                      aviso(context, 'Aviso', "Salvo!");
                    },
                  ),
                ]),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: Image.network(
                                      "https://d17lbu6bbzbdc8.cloudfront.net/wp-content/uploads/2020/06/10213859/solo-leveling-696x424.jpg")
                                  .image,
                              fit: BoxFit.cover),
                        ),
                      ),
                      TextField(
                        cursorColor: _corPrincipal,
                        decoration: InputDecoration(
                          labelText: "Nome",
                          labelStyle: TextStyle(color: _corPrincipal),
                          icon: Icon(
                            Icons.perm_contact_cal,
                            color: _corPrincipal,
                          ),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _nome,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextField(
                        cursorColor: _corPrincipal,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: _corPrincipal),
                          icon: Icon(
                            Icons.email,
                            color: _corPrincipal,
                          ),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _email,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextField(
                        cursorColor: _corPrincipal,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(color: _corPrincipal),
                          icon: Icon(
                            Icons.lock_open,
                            color: _corPrincipal,
                          ),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _senha,
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 170,
                            child: ListTile(
                              title: Text(
                                "Capitão",
                                style: TextStyle(color: _corPrincipal),
                              ),
                              leading: Radio(
                                activeColor: _corPrincipal,
                                value: _cargo.Capitao,
                                groupValue: _cargoControle,
                                onChanged: (_cargo value) {
                                  setState(() {
                                    _cargoControle = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                              width: 200,
                              child: ListTile(
                                title: Text(
                                  "Administrativo",
                                  style: TextStyle(color: _corPrincipal),
                                ),
                                leading: Radio(
                                  activeColor: _corPrincipal,
                                  value: _cargo.Administrativo,
                                  groupValue: _cargoControle,
                                  onChanged: (_cargo value) {
                                    setState(() {
                                      _cargoControle = value;
                                    });
                                  },
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context, titulo, texto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(titulo),
        content: new Text(texto),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
