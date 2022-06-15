

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class InputText extends StatefulWidget {
  Color cor;
  String label;
  bool isPassword;
  TextEditingController controller;

  InputText(this.cor, this.label, this.isPassword, {required this.controller});

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  var _focusNode = new FocusNode();
  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        focusNode: _focusNode,
        obscureText: widget.isPassword,
        enableSuggestions: widget.isPassword == true ? false : true,
        autocorrect: widget.isPassword == true ? false : true,
        controller: widget.controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus ? widget.cor : Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(
              color: widget.cor,
            )
          ),
          
        ),

    ),
  );
  }
}