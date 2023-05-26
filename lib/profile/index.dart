import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  late Future<Position> _getLocation;
  late double _latitude, _longitude;
  Marker? _selectedMarker;

  Future<Position> _setPosisiAwal() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;
    return position;
  }

  @override
  initState() {
    super.initState();
    _getLocation = _setPosisiAwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getLocation,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final latitude = data.latitude;
            final longitude = data.longitude;

            return GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex(latitude, longitude),
              markers: _createMarkers(),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              onLongPress: (value) async {
                _latitude = value.latitude;
                _longitude = value.longitude;
                final List<Placemark> title =
                    await placemarkFromCoordinates(_latitude, _longitude);
                setState(() {
                  _selectedMarker = Marker(
                    markerId: MarkerId(title[0].locality!),
                    position: LatLng(_latitude, _longitude),
                    infoWindow: InfoWindow(
                      title: title[0].subLocality,
                      snippet: title[0].locality,
                    ),
                  );
                });
              },
            );
          } else {
            return const Text("Gagal");
          }
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 50),
        child: FloatingActionButton(
          onPressed: _goToTheLake,
          child: const Icon(Icons.location_on_outlined),
        ),
      ),
    );
  }

  CameraPosition _kGooglePlex(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    return CameraPosition(
      target: LatLng(_latitude, _longitude),
      zoom: 14.4746,
    );
  }

  Future<void> _goToTheLake() async {
    await _getPosisi();
    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId('selected_marker'),
        position: LatLng(_latitude, _longitude),
        infoWindow: const InfoWindow(
          title: 'Lake Marker',
          snippet: 'Ini adalah penanda di danau',
        ),
      );
    });
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake()));
  }

  CameraPosition _kLake() {
    return CameraPosition(
      target: LatLng(_latitude, _longitude),
      zoom: 19.151926040649414,
    );
  }

  Future<Position> _getPosisi() async {
    Position position = await Geolocator.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;
    return position;
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    if (_selectedMarker != null) {
      markers.add(_selectedMarker!);
      return markers;
    }
    markers = <Marker>{
      Marker(
        markerId: const MarkerId('marker1'),
        position: LatLng(_latitude, _longitude),
        infoWindow: const InfoWindow(
          title: 'Marker 1',
          snippet: 'Ini adalah marker 1',
        ),
      ),
    };
    return markers;
  }
}
