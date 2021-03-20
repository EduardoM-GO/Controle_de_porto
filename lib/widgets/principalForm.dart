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

class _principalFormState extends State<principalForm>
    with SingleTickerProviderStateMixin {
  final _corPrincipal = Color(0xFF006876);
  final _corSegundaria = Colors.white;
  TabController _controllerTab;
  TextEditingController _pesquisa = TextEditingController();
  String _nome;
  String _cargo;
  String _pesquisaBarco = "";
  String _pesquisaCarga = "";
  String _pesquisaViagem = "";
  List<String> _lPesquisa = [
    "Nome Barco",
    "Nome Carga",
    "Nome Barco encarregado "
  ];

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
  void initState() {
    _controllerTab = new TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
    _peganome();
  }

  @override
  Widget build(BuildContext context) {
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
                                      "https://www.infoescola.com/wp-content/uploads/2012/02/capit%C3%A3o-de-navio_258334898.jpg")
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => barcosForm()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => cargaForm()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => viagemForm()));
                },
              ),
              Container(
                height:  MediaQuery.of(context).size.height*0.35,
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
      body: NestedScrollView(
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
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              expandedHeight: 100,
              title: Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Pesquisa',
                      labelStyle: TextStyle(color: _corSegundaria),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          Icons.search,
                          color: _corSegundaria,
                        ),
                        onTap: () {
                          setState(() {
                            if (_controllerTab.index == 0) {
                              _pesquisaBarco = _pesquisa.text;
                            }
                            if (_controllerTab.index == 1) {
                              _pesquisaCarga = _pesquisa.text;
                            }
                            if (_controllerTab.index == 2) {
                              _pesquisaViagem = _pesquisa.text;
                            }
                          });
                        },

                      ),
                      hintText: _lPesquisa[_controllerTab.index]),
                  style: TextStyle(color: _corSegundaria),
                  controller: _pesquisa,
                ),
              ),
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
                onTap: (i) {
                  setState(() {
                    _controllerTab;
                    if(_controllerTab.index == 0) {
                      _pesquisa.text = _pesquisaBarco;
                    }
                    if(_controllerTab.index == 1) {
                      _pesquisa.text = _pesquisaCarga;
                    }
                    if(_controllerTab.index == 2) {
                      _pesquisa.text = _pesquisaViagem;
                    }
                  });
                },
                controller: _controllerTab,
              ),


            ),

          ];
        },
        body: TabBarView(
          children: <Widget>[
            Tab(
              child: listaBarcos(context, _pesquisaBarco),
            ),
            Tab(
              child: listaCarga(context, _pesquisaCarga),
            ),
            Tab(
              child: listaViagem(context, _pesquisaViagem),
            ),
          ],
          controller: _controllerTab,

        ),
      ),
    );
  }
}
