import 'package:duda/Login.dart';
import 'package:duda/models/users.dart';
import 'package:duda/widget/input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/locais.dart';

class adicionarLocal extends StatefulWidget {
  const adicionarLocal({Key? key}) : super(key: key);

  @override
  State<adicionarLocal> createState() => _adicionarLocalState();
}

class _adicionarLocalState extends State<adicionarLocal> {
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final _nome = TextEditingController();
  final _descricao = TextEditingController();



  Future <void> inicializarFirebase() async {
    await Firebase.initializeApp();
    Firebase.initializeApp().whenComplete(()=>print('Conectado ao Firebase'));
  }

  @override
  Widget build(BuildContext context) {
    inicializarFirebase();
    return Scaffold(
      body: _laycomExpanded(),
    );
  }

  _laycomExpanded(){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              height: 250,
              color: Color.fromARGB(255, 231, 168, 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Locais', style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Mandali",
                    fontSize: 120,
                    fontWeight: FontWeight.w400,

                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0, 10.0),
                        blurRadius: 3.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),),
                ],
              )
          ),

          InputText(Color.fromARGB(255, 231, 168, 50), 'Latitude', false, controller: _latitude),
          InputText(Color.fromARGB(255, 231, 168, 50), 'Longitude', false, controller: _longitude),
          InputText(Color.fromARGB(255, 231, 168, 50), 'Nome', false, controller: _nome),
          InputText(Color.fromARGB(255, 231, 168, 50), 'Descrição', false, controller: _descricao),

          Container(
            width: 180,
            height: 70,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, //Cor do botão
                onPrimary: Colors.white, //Cor do trexto dentro do botão
                shape: RoundedRectangleBorder( // Deixando o botão circular
                  borderRadius: BorderRadius.circular(50), // <-- Radius
                ),),
              child: Text('Cadastrar'),
              onPressed: () {_clicksend(context);},
            ),
          ),
          SizedBox(height: size.height * 0.02),


        ],

      ),
    );
  }


  void _clicksend(BuildContext ctx){
    Locais l = new Locais();
    l.latitude = _latitude as double;
    l.longitude = _latitude as double;
    l.nome = _nome.text.toString().trim();
    l.descricao = _descricao.text.toString().trim();
    l.dt = DateTime.now();
    CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("locais");
    Future <void> addlocais(){
      return instanciaColecao
          .doc(l.dt.toString())
          .set(l.toJson())
          .then((value) => print("Local adicionado"))
          .catchError((onError)=>print("Erro ao gravar no banco $onError"));
    }
    addlocais();
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}