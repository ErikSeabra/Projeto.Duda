import 'package:duda/Cadastro.dart';
import 'package:duda/users/models/users.dart';
import 'package:duda/widget/error_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _user = TextEditingController();
  final _password = TextEditingController();

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
    return Scaffold(
      body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 250,
            color: Colors.deepPurple,
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
          
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
                controller: _user,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                ),

            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
              ),

            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            width: 230,
            height: 70,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple, //Cor do botão
              onPrimary: Colors.white, //Cor do trexto dentro do botão
              shape: RoundedRectangleBorder( // Deixando o botão circular
                borderRadius: BorderRadius.circular(50), // <-- Radius
              ),
              ),
              child: Text('Entrar'),
              onPressed: () {_logarConta(context);},
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Text(
            "OU",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            )
          ),         
          Container(
            width: 230,
            height: 70,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 231, 168, 50), //Cor do botão
              onPrimary: Colors.white, //Cor do trexto dentro do botão
              shape: RoundedRectangleBorder( // Deixando o botão circular
                borderRadius: BorderRadius.circular(50), // <-- Radius
              ),
              ),
              child: Text('Entrar sem cadastrar'),
              onPressed: () {_abreOutraTela(context, Mapa());},
            ),
          ),
          SizedBox(height: size.height * 0.02),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: "Não possui um cadastro? "),
                TextSpan(
                  text: "Crie uma conta",
                  style: TextStyle(color: Colors.deepPurple, fontWeight:FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = (() {
                    _abreOutraTela(context, Cadastro());
                  })
                )
              ],
            ),
          ),

        ],

      ),
    ),
    );
  }
  void _logarConta(BuildContext ctx, ){
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _user.text, 
      password: _password.text).then((value) {
        _abreOutraTela(ctx, Mapa());
    }).onError((error, stackTrace) {
      String erroNovo;
      if (error.toString() == "[firebase_auth/unknown] Given String is empty or null") {
        erroNovo = "Os campos não podem estar vazios, favor conferir e tentar novamente.";
      }else if(error.toString() == "[firebase_auth/invalid-email] The email address is badly formatted."){
        erroNovo = "O e-mail é inválido!";
      }else if(error.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
        erroNovo = "E-mail não encontrado, verifique suas credenciais ou crie um cadastro.";
      }else if(error.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
        erroNovo = "E-mail ou senha inválidos, verifique suas credenciais e tente novamente!";
      }else{
        erroNovo = error.toString();
      }
      print("Error ${error.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ErrorMessage("Erro",erroNovo),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      // Or use a `print('Could not launch $url')` instead.
    });
  }
  void _clicksend(BuildContext ctx) {
    Usuarios l = new Usuarios();
    l.user = _user.text.toString().trim();
    l.password = _password.text.toString();
    l.dt = DateTime.now();
    CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("users");
    Future <void> addUser(){
      return instanciaColecao
      .doc()
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
