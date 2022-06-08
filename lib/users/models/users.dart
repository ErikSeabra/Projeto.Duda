import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios {
  String user = '';
  String password = '';
  String nome = '';
  String telefone = '';


  DateTime dt = DateTime.now();

  Usuarios();

  Map<String, dynamic> toJson() => {
    'user':user,
    'nome':nome,
    'telefone':telefone,


    'dt': dt
  };

  Usuarios.fromSnapshot(DocumentSnapshot snapshot):
    user = snapshot['user'],
    nome = snapshot['nome'],
    telefone = snapshot['telefone'],

    dt = snapshot['dt'].toDate(); 
}