import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_barcos/widgets/barcosForm.dart';
import 'package:controle_barcos/widgets/cargaForm.dart';
import 'package:controle_barcos/widgets/viagemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

final _corPrincipal = Color(0xFF006876);
final _corSegundaria = Colors.white;
final _height = 2.0;
final _width = 10.0;

/*Notificação na tela*/
void aviso(BuildContext context, titulo, texto) {
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

void avisoDelete(BuildContext context, texto, db) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Exclusão"),
        content: new Text(texto),
        actions: <Widget>[
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Excluir"),
            onPressed: () {
              db.delete();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

/*Gera a Lista dos barcos*/
Widget listaBarcos(BuildContext context) {
  return Container(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Cadastro_de_barcos")
          .orderBy("Nome")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (ctx, i) => Container(
            padding: EdgeInsets.all(8),
            child: _barcoCard(documents, i, context),
          ),
        );
      },
    ),
  );
}

enum Popup { Edit, Delete }
/*Gera a Card dos barcos*/
Widget _barcoCard(documents, int i, BuildContext context) {
  return Container(
    child: GestureDetector(
      child: Card(
        color: _corPrincipal,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.79,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.drive_file_rename_outline,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Nome: " + documents[i]["Nome"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.anchor,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Capitão: " + documents[i]["Capitao"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Carga: " + documents[i]["Carga"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<Popup>(
                icon: Icon(
                  Icons.more_vert,
                  color: _corSegundaria,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Popup>>[
                  PopupMenuItem<Popup>(
                    value: Popup.Edit,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Editar',
                            style: TextStyle(color: _corPrincipal),
                          ),
                          Container(
                            width: 5,
                          ),
                          Icon(
                            Icons.edit,
                            color: _corPrincipal,
                          )
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<Popup>(
                      value: Popup.Delete,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Excluir',
                              style: TextStyle(color: _corPrincipal),
                            ),
                            Icon(
                              Icons.delete,
                              color: _corPrincipal,
                            )
                          ],
                        ),
                      )),
                ],
                onSelected: (Popup result) {
                  if (result == Popup.Delete) {
                    avisoDelete(
                        context,
                        "O Barco será excluído completamente!",
                        FirebaseFirestore.instance
                            .collection("Cadastro_de_barcos")
                            .doc(documents[i].reference.documentID.toString()));
                  } else if (result == Popup.Edit) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => barcosForm(
                          documents: documents[i],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InseriForm(documents: documents[i])));*/
      },
    ),
  );
}

/*Gera a Lista dos Carga*/
Widget listaCarga(BuildContext context) {
  return Container(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Cargas")
          .orderBy("Nome")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (ctx, i) => Container(
            padding: EdgeInsets.all(8),
            child: _cargaCard(documents, i, context),
          ),
        );
      },
    ),
  );
}

/*Gera a Card dos carga*/
Widget _cargaCard(documents, int i, BuildContext context) {
  return Container(
    child: GestureDetector(
      child: Card(
        color: _corPrincipal,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.79,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.drive_file_rename_outline,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Nome: " + documents[i]["Nome"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                              "Carga Viva: " +
                                  _truefalse(documents[i]["Carga Viva"]),
                              style: TextStyle(color: _corSegundaria)),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.fastfood_rounded,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Perecível: " +
                                _truefalse(documents[i]["Perecivel"]),
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_tree,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                              "Eletrônicos: " +
                                  _truefalse(documents[i]["Eletronicos"]),
                              style: TextStyle(
                                color: _corSegundaria,
                              )),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.fitness_center,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                              "Peso: " +
                                  documents[i]["Peso"].toString() +
                                  " KG",
                              style: TextStyle(color: _corSegundaria)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<Popup>(
                icon: Icon(
                  Icons.more_vert,
                  color: _corSegundaria,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Popup>>[
                  PopupMenuItem<Popup>(
                    value: Popup.Edit,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Editar',
                            style: TextStyle(color: _corPrincipal),
                          ),
                          Container(
                            width: 5,
                          ),
                          Icon(
                            Icons.edit,
                            color: _corPrincipal,
                          )
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<Popup>(
                      value: Popup.Delete,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Excluir',
                              style: TextStyle(color: _corPrincipal),
                            ),
                            Icon(
                              Icons.delete,
                              color: _corPrincipal,
                            )
                          ],
                        ),
                      )),
                ],
                onSelected: (Popup result) {
                  if (result == Popup.Delete) {
                    avisoDelete(
                        context,
                        "A Cargas será excluído completamente!",
                        FirebaseFirestore.instance
                            .collection("Cargas")
                            .doc(documents[i].reference.documentID.toString()));
                  } else if (result == Popup.Edit) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => cargaForm(
                          documents: documents[i],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InseriForm(documents: documents[i])));*/
      },
    ),
  );
}

/*Gera retorno do true e false*/
String _truefalse(entrada) {
  if (entrada == true) {
    return "Sim";
  } else {
    return "Não";
  }
}

/*Gera a Lista dos Viagem*/
Widget listaViagem(BuildContext context) {
  return Container(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Viagens")
          .orderBy("Barco")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.docs;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (ctx, i) => Container(
            padding: EdgeInsets.all(8),
            child: _viagemCard(documents, i, context),
          ),
        );
      },
    ),
  );
}

/*Gera a Card dos Viagem*/
Widget _viagemCard(documents, int i, BuildContext context) {
  return Container(
    child: GestureDetector(
      child: Card(
        color: _corPrincipal,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.79,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.directions_boat,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Barco: " + documents[i]["Barco"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place_outlined,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Local de Origem: " + documents[i]["Origem"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today_outlined,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Data de Chegada: " +
                                DateFormat("dd-MM-yyyy")
                                    .format(documents[i]["dtChegada"].toDate()),
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place_rounded,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Local de Destino: " + documents[i]["Destino"],
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                      Container(
                        height: _height,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: _corSegundaria,
                          ),
                          Container(
                            width: _width,
                          ),
                          Text(
                            "Data de Partida: " +
                                DateFormat("dd-MM-yyyy")
                                    .format(documents[i]["dtPartida"].toDate()),
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<Popup>(
                icon: Icon(
                  Icons.more_vert,
                  color: _corSegundaria,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Popup>>[
                  PopupMenuItem<Popup>(
                    value: Popup.Edit,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Editar',
                            style: TextStyle(color: _corPrincipal),
                          ),
                          Container(
                            width: 5,
                          ),
                          Icon(
                            Icons.edit,
                            color: _corPrincipal,
                          )
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<Popup>(
                      value: Popup.Delete,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Excluir',
                              style: TextStyle(color: _corPrincipal),
                            ),
                            Icon(
                              Icons.delete,
                              color: _corPrincipal,
                            )
                          ],
                        ),
                      )),
                ],
                onSelected: (Popup result) {
                  if (result == Popup.Delete) {
                    avisoDelete(
                        context,
                        "A Viagem será excluído completamente!",
                        FirebaseFirestore.instance
                            .collection("Viagens")
                            .doc(documents[i].reference.documentID.toString()));
                  } else if (result == Popup.Edit) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viagemForm(
                          documents: documents[i],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InseriForm(documents: documents[i])));*/
      },
    ),
  );
}
