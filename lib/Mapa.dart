import 'package:duda/Cadastro.dart';
import 'package:duda/Grupos.dart';
import 'package:duda/Login.dart';
import 'package:duda/mapa_alertas.dart';
import 'package:duda/mapa_eventos.dart';
import 'package:duda/mapa_locais.dart';
import 'package:duda/widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Mapa();
}

class _Mapa extends State<Mapa> {
  int _currentTabIndex = 0;
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
  
  @override
  Widget build(BuildContext context){
    _getCurrentUser();
    final _ktabPages = [
      mapaLocais(),
      mapaAlertas(),
      mapaEventos(),
    ];
    final _kBottmonNavBarItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.add_location_outlined), label: 'Locais'),
      const BottomNavigationBarItem(icon: Icon(Icons.warning_amber_outlined), label: 'Alertas'),
      const BottomNavigationBarItem(icon: Icon(Icons.where_to_vote_rounded), label: 'Eventos'),
    ];
    assert(_ktabPages.length ==  _kBottmonNavBarItems.length);
     final bottomNavBar = BottomNavigationBar(
         items: _kBottmonNavBarItems,
         currentIndex: _currentTabIndex,
         type: BottomNavigationBarType.fixed,
         onTap: (int index){
           setState(() {
             _currentTabIndex = index;
           });
         },
     );
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: _ktabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
      drawer: Drawer(
        child: MenuLateral(_uname, _email, anonimo),
      ),
    );
  }
}


class _NewPage extends MaterialPageRoute{
  _NewPage()
      : super(
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text('Page'),
            elevation: 1.0,
          ),
          body: Center(
              child: Text('page')
          ),
        );
      }
  );
}