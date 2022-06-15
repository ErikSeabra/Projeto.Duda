import 'package:duda/Login.dart';
import 'package:duda/mapa_locais.dart';
import 'package:duda/models/users.dart';
import 'package:duda/widget/error_message.dart';
import 'package:duda/widget/input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duda/widget/input_telefone.dart';


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
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Locais', style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Mandali",
                    fontSize: 100,
                    fontWeight: FontWeight.w400,

                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0, 8.0),
                        blurRadius: 30.0,
                        color: Color.fromARGB(255, 13, 61, 100),
                      ),
                    ],
                  ),),
                ],
              )
          ),

          InputPhone(Colors.blue, 'Latitude', false, false, controller: _latitude),
          InputPhone(Colors.blue, 'Longitude', false, false,controller: _longitude),
          InputText(Colors.blue, 'Nome', false, controller: _nome),
          InputText(Colors.blue, 'Descrição', false, controller: _descricao),

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
    l.latitude = double.parse(_latitude.text.toString());
    l.longitude = double.parse(_longitude.text.toString());
    l.nome = _nome.text.toString().trim();
    l.descricao = _descricao.text.toString().trim();
    l.dt = DateTime.now();
    CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("locais");
    Future <void> addlocais(){
      return instanciaColecao
          .doc()
          .set(l.toJson())
          .then((value) {
            print("Local adicionado");
            _abreOutraTela(ctx, Mapa());
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ErrorMessage("Sucesso","Local inserido com sucesso!", Colors.green),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 615),
              elevation: 0,
            ),
          );
          })
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