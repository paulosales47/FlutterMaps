import 'dart:async';
import 'package:geolocator/geolocator.dart';
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
  Set<Polygon> _poligonos = {};
  Set<Polyline> _linhas = {};

  Future<void> movimentarCamera() async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(-23.5143, -46.6004), zoom: 16, tilt: 45, bearing: 270)
    ));
  }

  void carregarMarcadores(){
    Marker marcadorA = Marker(markerId: MarkerId("vale-sul"),
      position: LatLng(-23.215421007011514, -45.89097817623199),
      infoWindow: InfoWindow(title: "Vale Sul"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta
      )
    );

    Marker marcadorB = Marker(markerId: MarkerId("center-vale"),
        position: LatLng(-23.183677552695187, -45.852558919904894),
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

  void carregarPoligonos(){
     Polygon poligonoA = Polygon(
       polygonId: PolygonId("A"),
       fillColor:  Colors.orange,
       strokeColor: Colors.red,
       strokeWidth: 10,
       points: [
         LatLng(-23.192176136013813, -45.78929207082668),
         LatLng(-23.196857392198442, -45.79005719497136),
         LatLng(-23.19780923580619, -45.78381429290133),
         LatLng(-23.193023575678847, -45.78307467640101)
       ],
       consumeTapEvents: true,
       onTap: (){
         print("clicado A");
       },
       zIndex: 1
     );

     Polygon poligonoB = Polygon(
         polygonId: PolygonId("A"),
         fillColor:  Colors.purple,
         strokeColor: Colors.blue,
         strokeWidth: 10,
         points: [
           LatLng(-23.196473614672886, -45.78616102029726),
           LatLng(-23.196632066210956, -45.784902317628095),
           LatLng(-23.19932677639783, -45.78537465230366),
           LatLng(-23.198830531225074, -45.786530667343584)
         ],
         consumeTapEvents: true,
         onTap: (){
           print("clicado B");
         },
         zIndex: 0
     );

     _poligonos.add(poligonoA);
     _poligonos.add(poligonoB);
  }

  void carregarLinhas(){

    Polyline linhaA = Polyline(
      polylineId: PolylineId("A"),
      color: Colors.red,
      width: 5,
      startCap: Cap.roundCap,
      jointType: JointType.round,
      points: [
        LatLng(-23.260530583975296, -45.94453178896132),
        LatLng(-23.193427964304, -45.792444606167685),
        LatLng(-23.256981029561093, -45.824272831740885),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("clicado na linha");
      }
    );


    _linhas.add(linhaA);

  }

  Future<void> recuperarLocalizacaoAtual() async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('GPS DESATIVADO');
    }

    permission = await Geolocator.checkPermission();

    //VERIFICA SE POSSUI A PERMISSÃO, SE NÃO TIVER FAZ A REQUISIÇÃO
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'ACESSO NEGADO AO SERVIÇO DE LOCALIZAÇÃO');
    }

    Position localizacaoAtual = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    print(localizacaoAtual.latitude);
    print(localizacaoAtual.longitude);
  }


  @override
  void initState() {
    super.initState();
    // carregarMarcadores();
    // carregarPoligonos();
    // carregarLinhas();
    recuperarLocalizacaoAtual();
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
            target: LatLng(-23.213886545142074, -45.89346589428589),
            zoom: 12
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: _marcadores,
          polygons: _poligonos,
          polylines: _linhas,
        ),
      ),
    );
  }
}
