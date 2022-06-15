import 'package:duda/Cadastro.dart';
import 'package:duda/CheckAuth.dart';
import 'package:duda/CriarGrupo.dart';
import 'package:duda/Loading02.dart';
import 'package:duda/Login.dart';
import 'package:duda/Mapa.dart';
import 'package:duda/widget/input_text.dart';
import 'package:duda/widget/menu.dart';
import 'package:duda/widget/modal_bloqueio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Grupos extends StatefulWidget {
  const Grupos({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Grupos();
}

class _Grupos extends State<Grupos> {
  late User mCurrentUser;
  String _uname = '';
  String _email = '';
  bool anonimo = false;

  late FirebaseAuth _auth;

  _getCurrentUser () async {
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

  _getGroups () async {
    QuerySnapshot grupos = await FirebaseFirestore.instance.collection('groups').get();
    List docs = grupos.docs;
    int _qtdGroups = docs.length;
    print(docs.length);
    docs.forEach((doc){
      //print(doc['nome']);
    });
  }


  @override
  Widget build(BuildContext context) {
    _getCurrentUser();
    _getGroups();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Grupos"),
      ),
      drawer: Drawer(
        child: MenuLateral(_uname, _email, anonimo),
      ),
      body: _telaGrupos(),
    );
  }
  _telaGrupos(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                IconButton(
                  tooltip: "Adicione um grupo",
                  onPressed: (){_abreOutraTela(context, CriarGrupo(_uname, _email, anonimo));}, 
                  icon: Icon(
                    Icons.add_circle_rounded, 
                    color: Color.fromARGB(255, 140, 165, 214), 
                    size: 30.0,
                    shadows: [
                      BoxShadow(
                        color: Color.fromARGB(150, 158, 158, 158),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: Offset(0, 2),

                      )
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(300, 0, 0, 0),
                ),
                
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 28, right: 30, top: 20),
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(101, 33, 149, 243),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: 
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text("Nome do grupo"),
                          ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 6),
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.facebook,size: 40,color: Colors.blue,)),
                      )
                    ],
                  ),
                  
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 28, right: 30, top: 25),
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(100, 58, 243, 33),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: 
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text("Nome do grupo"),
                          ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 6),
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.whatsapp,size: 40,color: Colors.green,)),
                      )
                    ],
                  ),
                  
                )

              ],
            )
          ),
              
        ],

      ),
    ),
    );
  }
}

_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}




