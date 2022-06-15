import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class InputPhone extends StatefulWidget {
  Color cor;
  String label;
  bool isPassword;
  bool isTelefone;
  TextEditingController controller;

  InputPhone(this.cor, this.label, this.isPassword, this.isTelefone, {required this.controller});

  @override
  State<InputPhone> createState() => _InputPhoneState();
}

class _InputPhoneState extends State<InputPhone> {
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
    var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) #####-####', 
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        inputFormatters: widget.isTelefone ? [maskFormatter] : [],
        focusNode: _focusNode,
        obscureText: widget.isPassword,
        enableSuggestions: widget.isPassword == true ? false : true,
        autocorrect: widget.isPassword == true ? false : true,
        controller: widget.controller,
        keyboardType: TextInputType.number,
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