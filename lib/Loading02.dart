import 'package:duda/Cadastro.dart';
import 'package:duda/Loading.dart';
import 'package:duda/Login.dart';
import 'package:duda/Mapa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Loading02 extends StatefulWidget {
  const Loading02({Key? key}) : super(key: key);

  @override
  State<Loading02> createState() => _Loading02State();
}

class _Loading02State extends State<Loading02> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _laycomExpanded(),
    );
  }
_laycomExpanded(){
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      child: Container(
        color: Color.fromARGB(52, 104, 58, 183),
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
            children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, //Cor do botão
                        onPrimary: Colors.white, //Cor do trexto dentro do botão
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder( // Deixando o botão circular
                          borderRadius: BorderRadius.circular(50), // <-- Radius
                        ),
                      ),
                      onPressed: () {_abreOutraTela(context, login());}, 
                      child: Text('Entrar'),
                    ),
                    SizedBox(height: size.height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, //Cor do botão
                        onPrimary: Colors.white, //Cor do trexto dentro do botão
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder( // Deixando o botão circular
                          borderRadius: BorderRadius.circular(50), // <-- Radius
                        ),
                      ),
                      onPressed: () {_abreOutraTela(context, Cadastro());}, 
                      child: Text('Cadastrar'),
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
                    SizedBox(height: size.height * 0.04),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 231, 168, 50), //Cor do botão
                        onPrimary: Colors.white, //Cor do trexto dentro do botão
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder( // Deixando o botão circular
                          borderRadius: BorderRadius.circular(50), // <-- Radius
                        ),
                      ),
                      onPressed: () {_abreOutraTela(context, Mapa());}, 
                      child: Text('Entrar sem cadastro'),
                    ),
                ],
                ),
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