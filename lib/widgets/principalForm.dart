import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:controle_barcos/widgets/usuarioForm.dart';
import 'package:controle_barcos/widgets/barcosForm.dart';
import 'package:controle_barcos/widgets/cargaForm.dart';
import 'package:controle_barcos/widgets/viagemForm.dart';
import 'package:controle_barcos/widgets/funcao.dart';
import 'package:flutter/widgets.dart';

class principalForm extends StatefulWidget {
  final email;

  principalForm(this.email);

  @override
  _principalFormState createState() => _principalFormState();
}

class _principalFormState extends State<principalForm> {
  String _nome;
  String _cargo;

  @override
  void initState() {
    super.initState();
    _peganome();
  }

  void _peganome() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("Usuario")
        .doc(widget.email.toString())
        .snapshots();
    snapshot.forEach((doc) async {
      setState(() {
        _nome = doc["Nome"];
        _cargo = doc["Tipo"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _corPrincipal = Color(0xFF006876);
    final _corSegundaria = Colors.white;
    return Scaffold(
      backgroundColor: _corSegundaria,
      drawer: Drawer(
        child: Container(
          color: _corPrincipal,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: Image.network(
                                      "https://d17lbu6bbzbdc8.cloudfront.net/wp-content/uploads/2020/06/10213859/solo-leveling-696x424.jpg")
                                  .image,
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_box_outlined,
                              color: _corSegundaria,
                              size: 16,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text("Nome: " + _nome.toString(),
                                style: TextStyle(color: _corSegundaria)),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.email,
                              color: _corSegundaria,
                              size: 16,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text("Email: " + widget.email.toString(),
                                style: TextStyle(color: _corSegundaria)),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.work_outline_outlined,
                              color: _corSegundaria,
                              size: 16,
                            ),
                            Container(
                              width: 5,
                            ),
                            Text("Cargo: " + _cargo.toString(),
                                style: TextStyle(color: _corSegundaria)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(Icons.people, color: _corSegundaria),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Usuário",
                          style: TextStyle(color: _corSegundaria),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => usuariosForm(
                              /*Email: userCredential.user.email*/)));
                },
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(
                            Icons.directions_boat_rounded,
                            color: _corSegundaria,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Barcos",
                          style: TextStyle(color: _corSegundaria),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => barcosForm(
                              /*Email: userCredential.user.email*/)));
                },
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(
                            Icons.work,
                            color: _corSegundaria,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Carga",
                          style: TextStyle(color: _corSegundaria),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              cargaForm(/*Email: userCredential.user.email*/)));
                },
              ),
              ListTile(
                title: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(
                            Icons.waves_sharp,
                            color: _corSegundaria,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Viagens",
                          style: TextStyle(color: _corSegundaria),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => viagemForm(
                              /*Email: userCredential.user.email*/)));
                },
              ),
              Container(
                height: 275,
              ),
              Container(
                child: ListTile(
                  title: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.logout,
                              color: _corSegundaria,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Logout",
                            style: TextStyle(color: _corSegundaria),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                backgroundColor: _corPrincipal,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      color: _corSegundaria,
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
                expandedHeight: 100,
                bottom: TabBar(
                  indicatorColor: _corSegundaria,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.directions_boat_rounded,
                        color: _corSegundaria,
                      ),
                      child: Text(
                        "Barco",
                        style: TextStyle(color: _corSegundaria),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.work, color: _corSegundaria),
                      child: Text(
                        "Carga",
                        style: TextStyle(color: _corSegundaria),
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.waves_sharp, color: _corSegundaria),
                      child: Text(
                        "Viagem",
                        style: TextStyle(color: _corSegundaria),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Tab(
                child: listaBarcos(context),
              ),
              Tab(
                child: listaCarga(context),
              ),
              Tab(
                child: listaViagem(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
