import 'package:duda/Login.dart';
import 'package:duda/models/users.dart';
import 'package:duda/widget/error_message.dart';
import 'package:duda/widget/input_telefone.dart';
import 'package:duda/widget/input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';


class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _user = TextEditingController();
  final _password = TextEditingController();
  final _nome = TextEditingController();
  ButtonState stateTextWithIcon = ButtonState.idle;
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
            InputPhone(Color.fromARGB(255, 231, 168, 50), 'Telefone', false, true, controller: _telefone),
    
            Container(
              width: 180,
              height: 70,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ProgressButton.icon(iconedButtons: {
                ButtonState.idle: IconedButton(
                  color: Color.fromARGB(255, 231, 168, 50),
                  text: "Cadastrar",
                ),
                ButtonState.loading: IconedButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  color: Color.fromARGB(255, 231, 168, 50),
                  text: "Carregando",
                ),
                ButtonState.fail: IconedButton(
                  color: Color.fromARGB(255, 231, 168, 50),
                  text: "Cadastrar",
                ),
                ButtonState.success: IconedButton(
                  text: "Sucesso",
                  color: Colors.green.shade400
                ),},
                onPressed: () {
                  _clicksend(context);
                },
                state: stateTextWithIcon,
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
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    if (_nome.text.toString().length > 0 && _telefone.text.toString().length > 0) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _user.text.trim(), 
        password: _password.text).then((value) {
          addDados(ctx, value.user?.email);
          _abreOutraTela(ctx, login());
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ErrorMessage("Sucesso","Usuário cadastrado com sucesso!", Colors.green),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            margin: EdgeInsets.only(bottom: 615),
            elevation: 0,
          ),
        );
        }).onError((error, stackTrace) {
          String erroNovo;
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          if (error.toString() == "[firebase_auth/unknown] Given String is empty or null") {
          erroNovo = "Os campos não podem estar vazios, favor conferir e tentar novamente.";
        }else if(error.toString() == "[firebase_auth/invalid-email] The email address is badly formatted."){
          erroNovo = "O e-mail é inválido!";
        }else if(error.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account."){
          erroNovo = "O e-mail informado já está em uso, favor cadastrar um novo e-mail ou solicitar a alteração de senha.";
        }else if(error.toString() == "[firebase_auth/weak-password] Password should be at least 6 characters"){
          erroNovo = "A senha precisa ter no mínimo 6 caracteres!";
        }else{
          erroNovo = error.toString();
        }
        print("Error ${error.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ErrorMessage("Erro",erroNovo, Colors.red),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            margin: EdgeInsets.only(bottom: 615),
            elevation: 0,
          ),
        );
        // Or use a `print('Could not launch $url')` instead.
      });
    }else{
      setState(() {
        stateTextWithIcon = ButtonState.idle;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ErrorMessage("Erro","Os campos não podem estar vazios, favor conferir e tentar novamente.", Colors.red),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(bottom: 615),
          elevation: 0,
        ),
      );
    }
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
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}
