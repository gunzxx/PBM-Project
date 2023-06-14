import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  late Future _getLocation;
  bool _locationActive = false;
  Set<Marker> _markers = {};

  Future _setPosisiAwal() async {
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
    final tempat =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _markers = <Marker>{
        Marker(
          markerId: MarkerId(tempat[0].locality!),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: tempat[0].subLocality!,
            snippet: tempat[0].locality!,
          ),
        ),
      };
    });

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
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _locationActive = true;
                });
                _mapController.complete(controller);
              },
              onLongPress: _changeMarker,
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Harap aktifkan GPS dan internet anda!"),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _getLocation = _setPosisiAwal();
                    });
                  },
                  child: const Text("Ulangi"),
                ),
              ],
            ));
          }
        },
      ),
      floatingActionButton: _locationActive == true
          ? Container(
              margin: const EdgeInsets.only(right: 50, bottom: 50),
              child: FloatingActionButton(
                onPressed: _goCurrentPosisition,
                child: const Icon(Icons.location_on_outlined),
              ),
            )
          : null,
    );
  }

  // CameraPosition _kGooglePlex(double latitude, double longitude) {
  //   return CameraPosition(
  //     target: LatLng(latitude, longitude),
  //     zoom: 14.4746,
  //   );
  // }

  _goCurrentPosisition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("GPS atau Internet tidak aktif"),
              content: Text("Harap aktifkan koneksi GPS anda, lalu coba lagi!"),
            );
          });
    }

    await Geolocator.getCurrentPosition().then((position) {
      setState(() {
        _markers = {};
        _markers.add(Marker(
          markerId: const MarkerId('selected_marker'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: 'Posisi saat ini',
            snippet: 'Ini adalah posisi anda sekarang',
          ),
        ));
      });

      _mapController.future.then((controller) {
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 20,
        )));
      });
    });
  }

  void _changeMarker(value) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("GPS tidak aktif"),
              content: Text("Harap aktifkan GPS anda, lalu coba lagi!"),
            );
          });
    }

    final connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      return showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Internet tidak aktif"),
              content:
                  Text("Harap aktifkan koneksi internet anda, lalu coba lagi!"),
            );
          });
    }
    final tempat =
        await placemarkFromCoordinates(value.latitude, value.longitude);
    setState(() {
      _markers = {};
      _markers.add(Marker(
        markerId: MarkerId(tempat[0].locality!),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: tempat[0].subLocality!,
          snippet: tempat[0].locality!,
        ),
      ));
    });
  }
}
