import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_barcos/widgets/funcao.dart';
import 'package:flutter/material.dart';

class cargaForm extends StatefulWidget {
  final documents;

  cargaForm({this.documents});

  @override
  _cargaFormState createState() => _cargaFormState();
}

class _cargaFormState extends State<cargaForm> {
  final _corPrincipal = Color(0xFF006876);
  final _corSegundaria = Colors.white;

  TextEditingController _nome = TextEditingController();
  TextEditingController _peso = TextEditingController();
  bool _cargaViva = false;
  bool _perecivel = false;
  bool _eletronicos = false;

  void initState() {
    super.initState();
    if (widget.documents != null) {
      setState(() {
        _nome.text = widget.documents["Nome"];
        _cargaViva = widget.documents["Carga Viva"];
        _perecivel = widget.documents["Perecivel"];
        _eletronicos = widget.documents["Eletronicos"];
        _peso.text = widget.documents["Peso"].toString();
      });
    }
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
                            "https://image.freepik.com/fotos-gratis/vista-aerea-do-navio-de-carga-do-conteiner-no-mar_335224-738.jpg")
                            .image,
                        fit: BoxFit.cover,
                        semanticLabel: "Teste",
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
                          "Cadastro de Carga",
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
                            .collection("Cargas")
                            .add({
                          "Nome": _nome.text,
                          "Carga Viva": _cargaViva,
                          "Eletronicos": _eletronicos,
                          "Perecivel": _perecivel,
                          "Peso": double.parse(_peso.text),
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection("Cargas")
                            .doc(widget.documents.reference.documentID
                                .toString())
                            .update({
                          "Nome": _nome.text,
                          "Carga Viva": _cargaViva,
                          "Eletronicos": _eletronicos,
                          "Perecivel": _perecivel,
                          "Peso": double.parse(_peso.text),
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
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Nome ",
                          icon: Icon(
                            Icons.work,
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
                      SwitchListTile(
                        title: const Text('Carga Viva'),
                        value: _cargaViva,
                        onChanged: (bool value) {
                          setState(() {
                            _cargaViva = value;
                          });
                        },
                        secondary: Icon(
                          Icons.favorite,
                          color: _corPrincipal,
                        ),
                        activeColor: _corPrincipal,
                      ),
                      Container(
                        height: 10,
                      ),
                      SwitchListTile(
                        title: const Text('Perecível'),
                        value: _perecivel,
                        onChanged: (bool value) {
                          setState(() {
                            _perecivel = value;
                          });
                        },
                        secondary: Icon(
                          Icons.fastfood_rounded,
                          color: _corPrincipal,
                        ),
                        activeColor: _corPrincipal,
                      ),
                      Container(
                        height: 10,
                      ),
                      SwitchListTile(
                        title: const Text('Eletrônicos'),
                        value: _eletronicos,
                        onChanged: (bool value) {
                          setState(() {
                            _eletronicos = value;
                          });
                        },
                        secondary: Icon(
                          Icons.account_tree,
                          color: _corPrincipal,
                        ),
                        activeColor: _corPrincipal,
                      ),
                      TextFormField(
                        cursorColor: _corPrincipal,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Peso (KG)",
                          icon: Icon(
                            Icons.fitness_center,
                            color: _corPrincipal,
                          ),
                          labelStyle: TextStyle(color: _corPrincipal),
                        ),
                        controller: _peso,
                        style: TextStyle(color: _corPrincipal),
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
