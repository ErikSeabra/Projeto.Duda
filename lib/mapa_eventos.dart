import 'dart:async';
import 'package:duda/Cadastro.dart';
import 'package:duda/adicionar_local.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class mapaEventos extends StatefulWidget {
  const mapaEventos({Key? key}) : super(key: key);

  @override
  State<mapaEventos> createState() => _mapaEventosState();
}

class _mapaEventosState extends State<mapaEventos> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(-23.641974650177538, -47.82745159127637), zoom: 14);

  Set<Marker> markers = {};
  List <Marker> _marker = [];
  final List<Marker> _list = const[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(-23.63950572000287, -47.82038710256803),
        infoWindow: InfoWindow(
            title: 'Nome: Confraternização',
            snippet: "R. das Hortências, 505 - Sarapui, Sarapuí - SP, 18220-000\nData 11/10/2022 10:30",
        )
    ),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(-23.599464235760536, -48.05185505542261),
        infoWindow: InfoWindow(
            title: 'Nome: Palesta',
            snippet: "R. Francisco Rodrigues Junior, 300 - Vila Barth, Itapetininga - SP, 18205-590\nData20/12/2022 14:00"
        )
    ),
    ];

  @override
  void initState(){
    super.initState();
    _marker.addAll(_list);
  }

  late User mCurrentUser;
  String _uname = '';
  String _email = '';
  bool anonimo = false;

  late FirebaseAuth _auth;

  _getCurrentUser () async {
    _auth = FirebaseAuth.instance;
    
    if (_auth.currentUser != null) {
      mCurrentUser = _auth.currentUser!;
      DocumentSnapshot usuario = await FirebaseFirestore.instance.collection('users').doc(mCurrentUser.email).get();
      setState(() {
        _uname = usuario["nome"] != '' ? usuario["nome"] : "";
        _email = usuario["user"] != '' ? usuario["user"] : "";
      });
    }else{
      setState(() {
        anonimo = true;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    _getCurrentUser();
    return Scaffold(

        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: Set<Marker>.of(_marker),
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [FloatingActionButton(
            onPressed: () async {
              Position position = await _determinePosition();

              googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 20)));


              markers.clear();

              markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

              setState(() {});

            },

            child: const Icon(Icons.center_focus_strong),
          ),
            FloatingActionButton(onPressed: (){
              if (anonimo) {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                  title: Text("Opss! Algo deu errado."),
                  content: Text("Os eventos só podem ser inseridos por usuários cadastrados. \n\nDeseja se cadastrar agora?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text("NÃO")
                    ),
                    TextButton(
                      onPressed: () => _abreOutraTela(context, Cadastro()), 
                      child: Text("SIM")
                    ),
                  ],),
                );
            }else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => adicionarLocal()));
            }
            },
              child: const Icon(Icons.add_location),)

          ],
        )

    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
_abreOutraTela(ctx, page){
  Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}