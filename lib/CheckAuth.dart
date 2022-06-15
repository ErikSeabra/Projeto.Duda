import 'package:duda/Grupos.dart';
import 'package:duda/Login.dart';
import 'package:duda/Mapa.dart';
import 'package:duda/widget/modal_bloqueio.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckAuth extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  bool userAutent = false;
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      userAutent = true;
    }
    return userAutent ? Grupos() : ModalBloqueio();
  }
}