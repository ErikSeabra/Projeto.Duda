import 'package:duda/Login.dart';
import 'package:duda/users/models/users.dart';
import 'package:duda/widget/input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _nome = TextEditingController();
  final _telefone = TextEditingController();



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
                Text('D', style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Mandali",
                  fontSize: 120,
                  fontWeight: FontWeight.w400,
                  
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 10.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(79, 58, 58, 1),
                    ),
                  ],
                ),),
              ],
            )
          ),
          
          InputText(Color.fromARGB(255, 231, 168, 50), 'Nome', false, controller: _nome),
          InputText(Color.fromARGB(255, 231, 168, 50), 'E-mail', false, controller: _user),
          InputText(Color.fromARGB(255, 231, 168, 50), 'Senha', true, controller: _password),
          InputText(Color.fromARGB(255, 231, 168, 50), 'Telefone', false, controller: _telefone),

          Container(
            width: 180,
            height: 70,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 231, 168, 50), //Cor do botão
              onPrimary: Colors.white, //Cor do trexto dentro do botão
              shape: RoundedRectangleBorder( // Deixando o botão circular
                borderRadius: BorderRadius.circular(50), // <-- Radius
              ),),
            child: Text('Cadastrar'),
            onPressed: () {_clicksend(context);},
            ),
          ),
          SizedBox(height: size.height * 0.02),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: "Já possui uma conta? "),
                TextSpan(
                  text: "Faça login",
                  style: TextStyle(color: Color.fromARGB(255, 231, 168, 50), fontWeight:FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = (() {
                    _abreOutraTela(context, login());
                  })
                )
              ],
            ),
          ),
          

        ],

      ),
    );
  }
  void _clicksend(BuildContext ctx) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: _user.text, 
      password: _password.text).then((value) {
        addDados(ctx, value.user?.email);
        _abreOutraTela(ctx, login());
      }).onError((error, stackTrace) {
        print("Error: ${error.toString()}");
    });
  }
  void addDados(BuildContext ctx, value){    
    Usuarios l = new Usuarios();
    l.user = _user.text.toString().trim();
    l.nome = _nome.text.toString().trim();
    l.telefone = _telefone.text.toString().trim();
    l.dt = DateTime.now();
    CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("users");
    Future <void> addUser(){
      return instanciaColecao
      .doc(value)
      .set(l.toJson())
      .then((value) => print("Usuario adicionado"))
      .catchError((onError)=>print("Erro ao gravar no banco $onError"));
    }
    addUser();
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}
