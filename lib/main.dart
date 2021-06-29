import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: "Mapas e Geolocalização",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

  Future<void> movimentarCamera() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(-23.5143, -46.6004), zoom: 16, tilt: 45, bearing: 270)
    ));
  }

  void carregarMarcadores(){
    Marker marcadorA = Marker(markerId: MarkerId("vale-sul"),
      position: LatLng(-23.2109299,-45.9100345),
      infoWindow: InfoWindow(title: "Vale Sul"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta
      )
    );

    Marker marcadorB = Marker(markerId: MarkerId("center-vale"),
        position: LatLng(-23.2066535,-45.9245497),
        infoWindow:InfoWindow(title: "Center Vale"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen
        ),
        rotation: 45,
        onTap: (){
          print("Center Vale");
        }
    );

    _marcadores.add(marcadorA);
    _marcadores.add(marcadorB);
  }

  @override
  void initState() {
    super.initState();
    carregarMarcadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: movimentarCamera,
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(-23.1947815,-45.8546547),
            zoom: 12
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: _marcadores,
        ),
      ),
    );
  }
}
