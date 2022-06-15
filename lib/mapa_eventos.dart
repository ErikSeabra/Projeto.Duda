import 'dart:async';
import 'package:duda/adicionar_local.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class mapaEventos extends StatefulWidget {
  const mapaEventos({Key? key}) : super(key: key);

  @override
  State<mapaEventos> createState() => _mapaEventosState();
}

class _mapaEventosState extends State<mapaEventos> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(-23.641974650177538, -47.82745159127637), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => adicionarLocal()));
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

