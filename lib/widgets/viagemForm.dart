import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_barcos/widgets/funcao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class viagemForm extends StatefulWidget {
  final documents;

  viagemForm({this.documents});

  @override
  _viagemFormSate createState() => _viagemFormSate();
}

class _viagemFormSate extends State<viagemForm> {
  final _corPrincipal = Color(0xFF006876);
  final _corSegundaria = Colors.white;

  var _barcoDisposnivel = [''];
  String _barco = "";

  TextEditingController _origem = TextEditingController();
  TextEditingController _partida = TextEditingController();
  TextEditingController _desino = TextEditingController();
  TextEditingController _chegada = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectBarco();
    if (widget.documents != null) {
      setState(() {
        _origem.text = widget.documents["Origem"];
        _partida.text = DateFormat("dd-MM-yyyy")
            .format(widget.documents["dtPartida"].toDate());
        _desino.text = widget.documents["Destino"];
        _chegada.text = DateFormat("dd-MM-yyyy")
            .format(widget.documents["dtChegada"].toDate());
      });
    }
  }

  void selectBarco() async {
    _barcoDisposnivel.clear();
    var snapshot = await FirebaseFirestore.instance
        .collection("Cadastro_de_barcos")
        .orderBy("Nome")
        .snapshots();

    snapshot.forEach((doc) async {
      _barco = doc.docs[0]["Nome"];
      print(doc.docs[0]["Nome"]);
      for (int i = 0; i < doc.size; i++) {
        if (widget.documents != null) {
          if (doc.docs[i]["Nome"] == widget.documents["Barco"]) {
            _barco = widget.documents["Barco"].toString();
          }
        }
        setState(() {
          print(doc.docs[i]["Nome"]);
          _barcoDisposnivel.add(doc.docs[i]["Nome"]);
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
                expandedHeight: 150.0,
                flexibleSpace: Container(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image(
                        image: Image.network(
                            "https://image.freepik.com/fotos-gratis/navio-porta-contentores-que-chega-no-porto-comercial_35024-895.jpg")
                            .image,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          //degrade na imagem
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withAlpha(0),
                              Colors.black12,
                              Colors.black45
                            ],
                          ),
                        ),
                        child: Text(
                          "Cadastro de Viagem",
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                    ],
                  ),
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
                            .collection("Viagens")
                            .add({
                          "Barco": _barco,
                          "Origem": _origem.text,
                          "dtPartida":
                              DateFormat("dd-MM-yyyy").parse(_partida.text),
                          "Destino": _desino.text,
                          "dtChegada":
                              DateFormat("dd-MM-yyyy").parse(_chegada.text),
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection("Viagens")
                            .doc(widget.documents.reference.documentID
                                .toString())
                            .set({
                          "Barco": _barco,
                          "Origem": _origem.text,
                          "dtPartida":
                              DateFormat("dd-MM-yyyy").parse(_partida.text),
                          "Destino": _desino.text,
                          "dtChegada":
                              DateFormat("dd-MM-yyyy").parse(_chegada.text),
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
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 50,
                      ),
                      Container(
                        child: DropdownButtonFormField<String>(
                          value: _barco,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: _corPrincipal),
                          decoration: InputDecoration(
                              labelText: "Barco",
                              labelStyle: TextStyle(color: _corPrincipal),
                              icon: Icon(
                                Icons.directions_boat,
                                color: _corPrincipal,
                              )),
                          onChanged: (String newValue) {
                            setState(() {
                              _barco = newValue;
                            });
                          },
                          items: _barcoDisposnivel
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
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Local de Origem",
                          icon: Icon(
                            Icons.place_outlined,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _origem,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "Data Partida",
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _partida,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Local de Destino",
                          icon: Icon(
                            Icons.place_rounded,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _desino,
                      ),
                      Container(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: "Data Chegada",
                          icon: Icon(
                            Icons.calendar_today,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        style: TextStyle(color: _corPrincipal),
                        controller: _chegada,
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
