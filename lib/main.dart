import 'package:datxanh_88_google_map/pages/google_maps_page.dart';
import 'package:datxanh_88_google_map/pages/location_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMapsPage(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Maps Sample App'),
      //     backgroundColor: Colors.green[700],
      //   ),
      //   body: GoogleMap(
      //     onMapCreated: _onMapCreated,
      //     initialCameraPosition: CameraPosition(
      //       target: _center,
      //       zoom: 11.0,
      //     ),
      //   ),
      // ),
    );
  }
}
