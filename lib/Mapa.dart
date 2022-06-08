import 'package:duda/Cadastro.dart';
import 'package:duda/Loading02.dart';
import 'package:duda/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Mapa();
}

class _Mapa extends State<Mapa>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _kTabPages = <Widget>[
    Center(child: Icon(Icons.battery_alert, size: 64.0, color: Colors.red)),
    Center(child: Icon(Icons.add_location_rounded, size: 64.0, color: Colors.cyan)),
    Center(child: Icon(Icons.accessible, size: 64.0, color: Colors.green)),
  ];
  static const _kTabs = <Tab>[

    Tab(icon: Icon(Icons.cloud), text: 'Alertas'),
    Tab(icon: Icon(Icons.alarm), text: 'Locais'),
    Tab(icon: Icon(Icons.forum), text: 'Eventos'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _kTabPages.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        bottom: new TabBar(
          controller: _tabController,
          tabs: [
            new Tab(icon: Icon(Icons.cloud), text: 'Alertas'),
            new Tab(icon: Icon(Icons.alarm), text: 'Locais'),
            new Tab(icon: Icon(Icons.forum), text: 'Eventos'),
          ],
        ),
      ),
      body: TabBarView(

        controller: _tabController,
        children: _kTabPages,
      ),
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


