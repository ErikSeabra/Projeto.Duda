import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CampoGrupo extends StatelessWidget {
  Size size;
  Color cor;
  Text nomeGrupo;

  CampoGrupo(this.size, this.cor, this.nomeGrupo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(left: 28, right: 30, top: 20),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: cor,
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
                child: Text("$nomeGrupo"),
              ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 6),
            child: IconButton(onPressed: (){}, icon: Icon(Icons.facebook,size: 40,color: cor,)),
          )
        ],
      ),
      
    );
  }
}