import 'package:cloud_firestore/cloud_firestore.dart';

class Grupo {
  String nome = '';
  String url = '';
  String user_doc = '';
  String rede = '';
  bool status = false;

  DateTime dt = DateTime.now();

  Grupo();

  Map<String, dynamic> toJson() => {
    'nome':nome,
    'url':url,
    'user_doc':user_doc,
    'rede':rede,
    'dt': dt,
    'status': false,
  };

  Grupo.fromSnapshot(DocumentSnapshot snapshot):
  nome = snapshot['nome'],
  url = snapshot['url'],
  user_doc = snapshot['user_doc'],
  rede = snapshot['rede'],
  status = false,
  dt = snapshot['dt'].toDate(); 
}