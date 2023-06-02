import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pariwisata_jember/mylib/color.dart';

import '../mylib/string.dart';

class TouristMap extends StatefulWidget {
  final Map _tourist;
  const TouristMap(this._tourist, {super.key});

  @override
  State<TouristMap> createState() => _TouristMapState(_tourist);
}

class _TouristMapState extends State<TouristMap> {
  _TouristMapState(this._tourist);
  final Map _tourist;
  late Future _location;
  final Completer<GoogleMapController> _mapCompleter =
      Completer<GoogleMapController>();
  bool _locationActive = false;
  Set<Marker> _markers = {};

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<Map> _getCurrentLocation() async {
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

    final Position position = await Geolocator.getCurrentPosition();
    String apiUrl =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf62481cfa0da9c90142b685ecce880e451d3d&start=${position.longitude},${position.latitude}&end=${_tourist['longitude']},${_tourist['latitude']}';

    http.Response response = await http.get(Uri.parse(apiUrl));

    final markers = {
      Marker(
        markerId: MarkerId(_tourist['name']),
        position: LatLng(double.parse(_tourist['latitude']),
            double.parse(_tourist['longitude'])),
        infoWindow: InfoWindow(
          title: _tourist['name'],
          snippet: strLimit(_tourist['location'], 25),
        ),
      ),
    };
    setState(() {
      _markers = markers;
    });

    Set<Polyline> polylines = {};

    if (response.statusCode == 200) {
      setState(() {
        _locationActive = true;
        markers.add(Marker(
          markerId: const MarkerId('selected_marker'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: 'Posisi saat ini',
            snippet: 'Ini adalah posisi anda sekarang',
          ),
        ));
        _markers = markers;
      });
      Map<String, dynamic> decodedJson = jsonDecode(response.body);

      List<dynamic> features = decodedJson['features'];

      for (var i = 0; i < features.length; i++) {
        final coordinates = features[i]['geometry']['coordinates'];
        print(features[i]);

        List<LatLng> points = [];
        for (var coordinate in coordinates) {
          double longitude = coordinate[0];
          double latitude = coordinate[1];
          points.add(LatLng(latitude, longitude));
        }
        setState(() {
          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: points,
          ));
        });
      }

      return {
        "markers": markers,
        "polylines": polylines,
      };
    }
    if (response.statusCode == 404) {
      setState(() {
        _locationActive = true;
        _markers = markers;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Rute tidak ditemukan."),
              content: Text("Tidak ada rute yang mengarah ke tempat tersebut."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Oke"))
              ],
            );
          });
      return {
        "markers": markers,
        "polylines": <Polyline>{},
      };
    }
    return {
      "markers": <Marker>{},
      "polylines": <Polyline>{},
    };
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _location = _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _locationActive
          ? Container(
              margin: EdgeInsets.only(right: 0, bottom: 90),
              child: IconButton(
                onPressed: _getCurrentPosisition,
                icon: Icon(Icons.place_outlined, color: b1, size: 45),
              ),
            )
          : null,
      body: FutureBuilder(
          future: _location,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final datas = snapshot.data!;
              _locationActive = true;
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(_tourist['latitude']),
                      double.parse(_tourist['longitude'])),
                  zoom: 14.4746,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapCompleter.complete(controller);
                },
                polylines: datas['polylines'],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Terjadi kesalahan : ${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sedang memuat peta,\nHarap tunggu!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  SpinKitThreeBounce(
                    color: Colors.blue,
                    size: 20,
                  )
                ],
              ),
            );
          }),
    );
  }

  _getCurrentPosisition() async {
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

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _locationActive = true;
      _markers.add(Marker(
        markerId: const MarkerId('selected_marker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: 'Posisi saat ini',
          snippet: 'Ini adalah posisi anda sekarang',
        ),
      ));
    });

    _mapCompleter.future.then((controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      )));
    });
  }
}
