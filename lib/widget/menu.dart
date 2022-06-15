import 'package:duda/Cadastro.dart';
import 'package:duda/Grupos.dart';
import 'package:duda/Login.dart';
import 'package:duda/Mapa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuLateral extends StatelessWidget {

  String _uname;
  String _email;
  bool anonimo;

  MenuLateral(this._uname, this._email, this.anonimo);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(_uname),
          accountEmail: Text(_email),
          /* currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: FlutterLogo(size: 42.0),
          ), */
          otherAccountsPictures: [
            IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut().then((value) {
                print("Usuário deslogado");
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => login())
                );
              });
              }, 
              icon: Icon(Icons.logout_outlined, color: Colors.white))
          ],
        ),
        ListTile(
          title: Text("Mapas"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Mapa())
              );
          },
        ),
        ListTile(
          title: Text("Grupos"),
          onTap: () {
            if (anonimo) {
              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                title: Text("Opss! Algo deu errado."),
                content: Text("Os grupos só podem ser acessados por usuários cadastrados. \n\nDeseja se cadastrar agora?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: Text("NÃO")
                  ),
                  TextButton(
                    onPressed: () => _abreOutraTela(context, Cadastro()), 
                    child: Text("SIM")
                  ),
                ],
              ),
              );
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => Grupos()));
            }
          },
        ),
        ListTile(
          title: const Text('Sair'),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Usuário deslogado");
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => login())
              );
            });
          },
        )
      ],
    );
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}