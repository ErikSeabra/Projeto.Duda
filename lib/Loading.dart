import 'package:flutter/material.dart';
import 'package:duda/Login.dart';

class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: _laycomExpanded(),
    );
  }

  _laycomExpanded(){
    return Container(
      color: Colors.amberAccent,
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
                        onPressed:() {_abreOutraTela(context, login());},
                        icon: Icon(
                          Icons.cloud,
                          color: Colors.white,
                          size: 50,
                        )
                    ),

                  ],
                )
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