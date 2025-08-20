import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  GoogleMapController? _controller;

  static const _inicial = CameraPosition(
    target: LatLng(-23.55052, -46.63331), // SP como exemplo
    zoom: 12,
  );

  final _marcadores = <Marker>{
    const Marker(
      markerId: MarkerId('centro-sp'),
      position: LatLng(-23.55052, -46.63331),
      infoWindow: InfoWindow(title: 'Centro de SP'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _inicial,
        onMapCreated: (c) => _controller = c,
        markers: _marcadores,
        myLocationEnabled: true,      // Mostra o ponto azul (precisa permissão)
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
