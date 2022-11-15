import 'package:cloud_firestore/cloud_firestore.dart';

class Locais {
  double latitude = 0.0;
  double longitude = 0.0;
  String nome = '';
  String descricao = '';
  String tipo = '';
  bool status = false;


  DateTime dt = DateTime.now();

  Locais();

  Map<String, dynamic> toJson() => {
    'latitude':latitude,
    'longitude':longitude,
    'nome':nome,
    'descricao':descricao,
    'tipo':tipo,
    'status': false,
    'dt': dt
  };

  Locais.fromSnapshot(DocumentSnapshot snapshot):
        latitude = snapshot['latitude'],
        longitude = snapshot['longitude'],
        nome = snapshot['nome'],
        descricao = snapshot['descricao'],
        tipo = snapshot['tipo'],
        status = false,
        dt = snapshot['dt'].toDate();
} 