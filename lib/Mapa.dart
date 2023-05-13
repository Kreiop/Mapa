import 'dart:ffi';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';

class Mapita extends StatefulWidget {
  const Mapita({super.key});

  @override
  State<Mapita> createState() => _MapitaState();
}

class _MapitaState extends State<Mapita> {
  late MapController _mapController;
  LatLng Puntero = LatLng(7.087802, -70.750408);
  String Datos = "";
  LatLng punto = LatLng(0, 0);

  @override
  void initState() {
    _mapController = MapController();
    final _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        Mapita(); //este es el widget que necesito que se refresque cada segundo
      });
    });
    super.initState();
    _inicio();
  }

  Future<Position> _inicio() async {
    final PosicionActual = await Geolocator.getCurrentPosition();
    punto.latitude = PosicionActual.latitude;
    punto.longitude = PosicionActual.longitude;
    return await Geolocator.getCurrentPosition();
  }

  Future<String> Direccion(double latitud, double longitud) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latitud, longitud);
    Placemark Actual = placemark[0];
    Datos = '${Actual.street}, ${Actual.locality}, ${Actual.subLocality}';
    return Datos;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onTap: (tapPosition, point) async {
            Direccion(point.latitude, point.longitude);
            setState(() {
              Puntero = point;
            });
          },
          center: punto,
          zoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                  point: Puntero,
                  builder: (context) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      )),
              Marker(
                  point: punto,
                  builder: (context) => Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 20.0,
                      )),
            ],
          ),
        ],
      ),
      Positioned(
        bottom: 20,
        left: 20,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.zoom_in,
            ),
            onPressed: () {
              var Acercar = _mapController.zoom + 0.5;
              _mapController.move(_mapController.center, Acercar);
            },
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.zoom_out,
            ),
            onPressed: () {
              var Acercar = _mapController.zoom - 0.5;
              _mapController.move(_mapController.center, Acercar);
            },
          ),
        ),
      ),
      Positioned(
          bottom: 20,
          right: 180,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.gps_fixed,
              ),
              onPressed: () async {
                Direccion(punto.latitude, punto.longitude);
                _mapController.move(punto, 16);
              },
            ),
          )),
      Align(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          margin: EdgeInsets.only(bottom: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    Datos,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
