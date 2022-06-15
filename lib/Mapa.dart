import 'package:duda/Cadastro.dart';
import 'package:duda/Loading02.dart';
import 'package:duda/Login.dart';
import 'package:duda/mapa_alertas.dart';
import 'package:duda/mapa_eventos.dart';
import 'package:duda/mapa_locais.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Mapa();
}

class _Mapa extends State<Mapa> {
  int _currentTabIndex = 0;
  
  @override
  Widget build(BuildContext context){
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
    const drawerHeader = UserAccountsDrawerHeader(
      accountName: Text('Usuario'),
      accountEmail: Text('Usuario@gmail.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: FlutterLogo(size: 42.0),
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Colors.amber,
          child: Text('A'),
        )
      ],
    );
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: const Text('Grupos'),
          onTap: () => Navigator.of(context).push(_NewPage()),
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
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: _ktabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
      drawer: Drawer(
        child: drawerItems,
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