import 'dart:async';
import 'package:duda/Cadastro.dart';
import 'package:duda/adicionar_local.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class mapaAlertas extends StatefulWidget {
  const mapaAlertas({Key? key}) : super(key: key);

  @override
  State<mapaAlertas> createState() => _mapaAlertasState();
}

class _mapaAlertasState extends State<mapaAlertas> {
  
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(-23.641974650177538, -47.82745159127637), zoom: 14);

  Set<Marker> markers = {};
  List <Marker> _marker = [];
  final List<Marker> _list = const[
    Marker(
        markerId: MarkerId('1'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(-23.63950572000287, -47.82038710256803),
        infoWindow: InfoWindow(
            title: 'Nome: Falta de acessibilidade',
            snippet: "R. das Hortências, 505 - Sarapui, Sarapuí - SP, 18220-000",
        )
    ),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(-23.599916486072374, -48.050642696974656),
        infoWindow: InfoWindow(
            title: 'Nome: Falta de acessibilidade',
            snippet: "R. Francisco Rodrigues Junior, 251 - Central Parque 4-L, Itapetininga - SP, 18205-590"
        )
    ),
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(-23.600634184452854, -48.05227348001969),
        infoWindow: InfoWindow(
          title: "Desaparecimento",
          snippet: "R. José Calazans Luz, 200 - Vila Barth, Itapetininga - SP, 18205-520"
            
        )
    )
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
                  content: Text("Os alertas só podem ser inseridos por usuários cadastrados. \n\nDeseja se cadastrar agora?"),
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