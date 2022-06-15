import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorMessage extends StatelessWidget {
  String errorText;
  String text;
  Color cor;


  ErrorMessage(this.text, this.errorText, this.cor);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        height: 90,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              errorText,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        )
      )
    );
  }
}