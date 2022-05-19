import 'package:flutter/material.dart';
import 'package:duda/Mapa.dart';


class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _laycomExpanded(),
    );
  }

  _laycomExpanded(){
    return Container(
      color: Colors.deepPurpleAccent,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                color: Colors.deepPurple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed:() {_abreOutraTela(context, Mapa());},
                        icon: Icon(
                          Icons.lock_clock,
                          color: Colors.white,
                          size: 50,
                        )
                    ),

                  ],
                )
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
                decoration: InputDecoration(
                  labelText: 'Enter an integer:',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),

                  ),
                ),

            ),
          ),

        ],

      ),
    );
  }

}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}
