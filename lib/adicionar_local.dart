import 'package:duda/Login.dart';
import 'package:duda/mapa_locais.dart';
import 'package:duda/models/users.dart';
import 'package:duda/widget/error_message.dart';
import 'package:duda/widget/input_text.dart';
import 'package:duda/widget/menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duda/widget/input_telefone.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';


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
  List<String> list = <String>['Alerta', 'Local', 'Evento'];
  String selectedValue = "";

  late FirebaseAuth _auth;
   late User mCurrentUser;
  String _uname = '';
  String _email = '';
  bool anonimo = false;
  int grupos = 0;

  ButtonState stateTextWithIcon = ButtonState.idle;

  getCurrentUser () async {
    _auth = FirebaseAuth.instance;
    
    if (_auth.currentUser != null) {
      mCurrentUser = _auth.currentUser!;
      DocumentSnapshot usuario = await FirebaseFirestore.instance.collection('users').doc(mCurrentUser.email).get();
      setState(() {
        _uname = usuario["nome"] != '' ? usuario["nome"] : "";
        _email = usuario["user"] != '' ? usuario["user"] : "";
      });
    }else{
      setState(() {
        anonimo = true;
      });
    }
  }

  Future <void> inicializarFirebase() async {
    await Firebase.initializeApp();
    Firebase.initializeApp().whenComplete(()=>print('Conectado ao Firebase'));
  }

  @override
  Widget build(BuildContext context) {
    inicializarFirebase();
    getCurrentUser();
    return Scaffold(
      body: _laycomExpanded(),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Cadastro de marcador"),
      ),
      drawer: Drawer(
        child: MenuLateral(_uname, _email, anonimo),
      ),
    );
  }

  _laycomExpanded(){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              height: 200,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Marcador', style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Mandali",
                    fontSize: 70,
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

          InputText(Colors.blue, 'Nome', false, controller: _nome),
          InputText(Colors.blue, 'Descrição', false, controller: _descricao),
          InputPhone(Colors.blue, 'Latitude', false, false, controller: _latitude),
          InputPhone(Colors.blue, 'Longitude', false, false,controller: _longitude),
          
          SizedBox(height: size.height*0.02,),

          Container(
            width: 350.0,
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<String>(
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toLowerCase(),
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255,167,196,254),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(
                      color:Color.fromARGB(255, 67, 67, 67),
                    )
                  ),
                  
                ),
                onChanged: (String? newValue){
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
            ),
          ),

                

          Container(
            width: 180,
            height: 70,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ProgressButton.icon(iconedButtons: {
                ButtonState.idle: IconedButton(
                  color: Colors.blue,
                  text: "Cadastrar",
                ),
                ButtonState.loading: IconedButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  color: Colors.blue,
                  text: "Carregando",
                ),
                ButtonState.fail: IconedButton(
                  color: Colors.blue,
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
            
            // child: ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.blue, //Cor do botão
            //     onPrimary: Colors.white, //Cor do trexto dentro do botão
            //     shape: RoundedRectangleBorder( // Deixando o botão circular
            //       borderRadius: BorderRadius.circular(50), // <-- Radius
            //     ),),
            //   child: Text('Cadastrar'),
            //   onPressed: () {_clicksend(context);},
            // ),
          ),
          SizedBox(height: size.height * 0.02),


        ],

      ),
    );
  }


  void _clicksend(BuildContext ctx){
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    Locais l = new Locais();
    if (_latitude.text.toString().trim() == "" || _longitude.text.toString().trim() == "" || 
      _nome.text.toString().trim() == "" ||_descricao.text.toString().trim() == ""
    ) {
      setState(() {
        stateTextWithIcon = ButtonState.idle;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ErrorMessage("Erro","Todos os campos precisam estar preenchidos, verifique e tente novamente!", Colors.red),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            margin: EdgeInsets.only(bottom: 615),
            elevation: 0,
          ),
        );
    }else{
      l.latitude = double.parse(_latitude.text.toString());
      l.longitude = double.parse(_longitude.text.toString());

      l.nome = _nome.text.toString().trim();
      l.descricao = _descricao.text.toString().trim();
      l.dt = DateTime.now();
      l.tipo = selectedValue.trim();

      CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("locais");
      Future <void> addlocais(){
        return instanciaColecao
            .doc()
            .set(l.toJson())
            .then((value) {
              print("Marcador adicionado");
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
              _abreOutraTela(ctx, Mapa());
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: ErrorMessage("Sucesso","Marcador adicionado com sucesso!", Colors.green),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                margin: EdgeInsets.only(bottom: 615),
                elevation: 0,
              ),
            );
            })
            .catchError((onError)=>{print("Erro ao gravar no banco $onError")});
      }
      addlocais();
    }
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}