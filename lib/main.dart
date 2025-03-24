import 'package:datxanh_88_google_map/pages/mapbox_page.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final token =
    'pk.eyJ1Ijoia2FuZ2YxIiwiYSI6ImNtOGk2NTAydDA4Nncya211dTN3bjl3czgifQ.gEtB60ZQIvUnkCa7-N3JHg';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String accessToken = String.fromEnvironment(token);
  MapboxOptions.setAccessToken(token);

  // Define options for your camera
  CameraOptions camera = CameraOptions(
    center: Point(coordinates: Position(-98.0, 39.5)),
    zoom: 2,
    bearing: 0,
    pitch: 0,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapboxPage(),
    );
  }
}
