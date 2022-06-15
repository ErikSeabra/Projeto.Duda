import 'package:cloud_firestore/cloud_firestore.dart';

class Locais {
  double latitude = 0.0;
  double longitude = 0.0;
  String nome = '';
  String descricao = '';


  DateTime dt = DateTime.now();

  Locais();

  Map<String, dynamic> toJson() => {
    'latitude':latitude,
    'longitude':longitude,
    'nome':nome,
    'descricao':descricao,


    'dt': dt
  };

  Locais.fromSnapshot(DocumentSnapshot snapshot):
        latitude = snapshot['latitude'],
        longitude = snapshot['longitude'],
        nome = snapshot['nome'],
        descricao = snapshot['descricao'],

        dt = snapshot['dt'].toDate();
}