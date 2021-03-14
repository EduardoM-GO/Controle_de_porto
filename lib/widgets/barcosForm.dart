import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_barcos/widgets/funcao.dart';
import 'package:flutter/material.dart';

class barcosForm extends StatefulWidget {
  final documents;

  barcosForm({this.documents});

  @override
  _barcosFromState createState() => _barcosFromState();
}

class _barcosFromState extends State<barcosForm> {
  final _corPrincipal = Color(0xFF006876);
  final _corSegundaria = Colors.white;

  TextEditingController _nome = TextEditingController();

  var _capitaoDisposnivel = [""];
  var _cargaDisposnivel = [""];
  String _capitao = "";
  String _carga = "";
  int _validaCapitao;

  void initState() {
    super.initState();
    selectCapitao();
    selectCarga();
    if (widget.documents != null) {
      setState(() {
        _nome.text = widget.documents["Nome"];
      });
    }
  }

  void selectCapitao() async {
    _capitaoDisposnivel.clear();
    var snapshot = await FirebaseFirestore.instance
        .collection("Usuario")
        .orderBy("Nome")
        .where("Tipo", isEqualTo: "capitao")
        .snapshots();

    snapshot.forEach((doc) async {
      _capitao = doc.docs[0]["Nome"];
      for (int i = 0; i < doc.size; i++) {
        setState(() {
          if (doc.docs[i]["Nome"] == widget.documents["Capitao"]) {
            _capitao = widget.documents["Capitao"].toString();
          }
          _capitaoDisposnivel.add(doc.docs[i]["Nome"]);
        });
      }
    });
  }

  void selectCarga() async {
    _cargaDisposnivel.clear();
    var snapshot = await FirebaseFirestore.instance
        .collection("Cargas")
        .orderBy("Nome")
        .snapshots();

    snapshot.forEach((doc) async {
      _carga = doc.docs[0]["Nome"];
      for (int i = 0; i < doc.size; i++) {
        setState(() {
          if (doc.docs[i]["Nome"] == widget.documents["Carga"]) {
            _carga = widget.documents["Carga"].toString();
          }
          _cargaDisposnivel.add(doc.docs[i]["Nome"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _corSegundaria,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: _corPrincipal,
                foregroundColor: _corSegundaria,
                expandedHeight: 150.0,
                flexibleSpace: const FlexibleSpaceBar(
                  background: FlutterLogo(),
                  title: Text('Cadastro de Barcos'),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: _corSegundaria,
                    ),
                    onPressed: () async {
                      if (widget.documents == null) {
                        await FirebaseFirestore.instance
                            .collection("Cadastro_de_barcos")
                            .add({
                          "Nome": _nome.text,
                          "Capitao": _capitao,
                          "Carga": _carga,
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection("Cadastro_de_barcos")
                            .doc(widget.documents.reference.documentID
                                .toString())
                            .set({
                          "Nome": _nome.text,
                          "Capitao": _capitao,
                          "Carga": _carga,
                        });
                      }
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
                  color: _corSegundaria,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                      ),
                      TextField(
                        cursorColor: _corPrincipal,
                        decoration: InputDecoration(
                          labelText: "Nome",
                          icon: Icon(
                            Icons.drive_file_rename_outline,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _nome,
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          value: _capitao,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: _corPrincipal),
                          decoration: InputDecoration(
                              labelText: "Capitão",
                              labelStyle: TextStyle(color: _corPrincipal),
                              icon: Icon(
                                Icons.anchor,
                                color: _corPrincipal,
                              )),
                          onChanged: (String newValue) {
                            setState(() {
                              _capitao = newValue;
                            });
                          },
                          items: _capitaoDisposnivel
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          value: _carga,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: _corPrincipal),
                          decoration: InputDecoration(
                              labelText: "Carga",
                              labelStyle: TextStyle(color: _corPrincipal),
                              icon: Icon(
                                Icons.work,
                                color: _corPrincipal,
                              )),
                          onChanged: (String newValue) {
                            setState(() {
                              _carga = newValue;
                            });
                          },
                          items: _cargaDisposnivel
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
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
