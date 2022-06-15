import 'package:duda/Grupos.dart';
import 'package:duda/models/grupos.dart';
import 'package:duda/widget/error_message.dart';
import 'package:duda/widget/input_text.dart';
import 'package:duda/widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class CriarGrupo extends StatefulWidget {
  String name;
  String email;
  bool anoniomo;

  CriarGrupo(this.name,this.email, this.anoniomo);


  @override
  State<CriarGrupo> createState() => _CriarGrupoState();
  
}

class _CriarGrupoState extends State<CriarGrupo> {

  final _nome = TextEditingController();
  final _url = TextEditingController();
  final _userDoc = TextEditingController();
  final _redeS = TextEditingController();


  Future <void> inicializarFirebase() async {
    await Firebase.initializeApp();
    Firebase.initializeApp().whenComplete(()=>print('Conectado ao Firebase'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Grupos"),
      ),
      drawer: Drawer(
        child: MenuLateral(widget.name, widget.email, widget.anoniomo),
      ),
      body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: size.height* 0.25,
            color: Color.fromARGB(255,167,196,254),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Icon(Icons.group, color: Colors.white, size: 30,),
                //SizedBox(height: size.height*0.01),
                Text('Grupos', style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Mandali",
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                    
                  ),),
              ],
            )
          ),
          Container(
            height: size.height*0.025,
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), 
                topRight: Radius.circular(30), 
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
              color: Colors.white,
            ),
          ),
          Container(
            height: size.width,
            width: size.width,
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),            
            color: Colors.white,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                InputText(Color.fromARGB(255,167,196,254), "Nome do Grupo", false, controller: _nome),
                SizedBox(height: size.height*0.02,),
                InputText(Color.fromARGB(255,167,196,254), "Link do Grupo", false, controller: _url),
                SizedBox(height: size.height*0.02,),
                InputText(Color.fromARGB(255,167,196,254), "Rede social (Facebook ou Whatsapp)", false, controller: _redeS),
                SizedBox(height: size.height*0.02,),


                Container(
                  width: 180,
                  height: 70,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255,167,196,254), //Cor do botão
                    onPrimary: Colors.white, //Cor do trexto dentro do botão
                    shape: RoundedRectangleBorder( // Deixando o botão circular
                      borderRadius: BorderRadius.circular(50), // <-- Radius
                    ),),
                  child: Text('Cadastrar'),
                  onPressed: () {addDados(context);},
                  ),
                ),
              ],
            )
          ),
              
        ],

      ),
    ),
    );
  }    
  void addDados(BuildContext ctx){    
    Grupo l = new Grupo();
    l.nome = _nome.text.toString().trim();
    l.url = _url.text.toString().trim();
    l.user_doc = widget.email.trim();
    l.rede = _redeS.text.toString().trim();
    l.dt = DateTime.now();
    print(_redeS.text.toUpperCase());

    if (_redeS.text.toUpperCase().trim() == "FACEBOOK" || _redeS.text.toUpperCase() == "WHATSAPP") {
      CollectionReference instanciaColecao = FirebaseFirestore.instance.collection("groups");
      Future <void> addGroup(){
        return instanciaColecao
        .doc()
        .set(l.toJson())
        .then((value) {
          print("Grupo adicionado");
          _abreOutraTela(ctx, Grupos());
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ErrorMessage("Sucesso","Grupo cadastrado com sucesso!", Colors.green),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 615),
              elevation: 0,
            ),
          );
        }
        )
        .catchError((onError){
          print("Error ${onError.toString()}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ErrorMessage("Erro",onError.toString(), Colors.red),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 615),
              elevation: 0,
            ),
          );
        });
      }
      addGroup();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ErrorMessage("Erro!","Digite 'Facebook' ou 'Whatsapp' para identificar a rede.", Colors.red),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          margin: EdgeInsets.only(bottom: 615),
          elevation: 0,
        )
      );
    }

  }

}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}