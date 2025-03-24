import 'package:datxanh_88_google_map/models/request/title_query_request.dart';
import 'package:datxanh_88_google_map/models/response/title_query_response.dart';
import 'package:datxanh_88_google_map/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxPage extends HookWidget {
  const MapboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = useState<LatLng?>(null);
    final location = useMemoized(() => Location());

    useEffect(() {
      Future<void> checkPermissions() async {
        bool serviceEnabled;
        PermissionStatus permissionGranted;

        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            return;
          }
        }

        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            return;
          }
        }
      }

      checkPermissions();

      location.onLocationChanged.listen((LocationData currentLocationData) {
        if (currentLocationData.latitude != null &&
            currentLocationData.longitude != null) {
          final latLng = LatLng(
            currentLocationData.latitude!,
            currentLocationData.longitude!,
          );
          currentLocation.value = latLng;
        }
      });
      return null;
    }, [location]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map box'),
      ),
      body: currentLocation.value == null
          ? const Center(child: CircularProgressIndicator())
          : MapWidget(
              styleUri: MapboxStyles.MAPBOX_STREETS,
              mapOptions: MapOptions(pixelRatio: 4),
              onMapCreated: (map) => _onMapCreated(map, currentLocation.value!),
            ),
    );
  }

  void _onMapCreated(MapboxMap map, LatLng current) async {
    map.logo.updateSettings(LogoSettings(enabled: false));
    map.attribution.updateSettings(AttributionSettings(enabled: false));
    map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    map.location.updateSettings(LocationComponentSettings(enabled: true));
    final response =
        await _fetchTitleQuery(Position(current.longitude, current.latitude));
    final center = Point(
      coordinates: Position(current.longitude, current.latitude),
    );
    await map.setCamera(
      CameraOptions(
        center: center,
        zoom: 15,
        anchor: ScreenCoordinate(x: 0, y: 0),
      ),
    );
    await map.flyTo(
      CameraOptions(
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: 15,
        pitch: 30,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
    if (response != null) {
      map.annotations.createPointAnnotationManager().then((point) async {
        final bytes = await rootBundle.load('assets/icons/point_blue.png');
        final list = bytes.buffer.asUint8List();
        var options = <PointAnnotationOptions>[];
        for (final feature in response.features) {
          options.add(
            PointAnnotationOptions(
              geometry: Point(
                coordinates: Position(
                  feature.geometry?.coordinates?[0] ?? 0,
                  feature.geometry?.coordinates?[1] ?? 0,
                ),
              ),
              image: list,
              textField:
                  feature.properties?.nameVi ?? feature.properties?.name ?? '',
              textOffset: [0, -3],
              textSize: 12,
              textColor: Colors.deepOrangeAccent.value,
              iconSize: .6,
            ),
          );
        }
        point.createMulti(options);
        point.addOnPointAnnotationClickListener(AnnotationClickListener());
      });
    }

    map.annotations.createCircleAnnotationManager().then((value) {
      value.create(CircleAnnotationOptions(
        geometry: Point(coordinates: Position(0.381457, 6.687337)),
        circleColor: Colors.yellow.value,
        circleRadius: 12.0,
      ));

      var options = <CircleAnnotationOptions>[];
      for (var i = 0; i < 120; i++) {
        options.add(CircleAnnotationOptions(
            geometry: createRandomPoint(),
            circleColor: createRandomColor(),
            circleRadius: 8.0));
      }
      value.createMulti(options);
    });
  }

  Future<QueryResponse?> _fetchTitleQuery(Position target) async {
    QueryResponse? response;
    try {
      final options = BaseOptions(
        baseUrl: 'https://api.mapbox.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      );
      final dio = Dio(options);
      final request = QueryRequest();
      final res = await dio.get(
        titleQueryEndpoint(target),
        queryParameters: request.toJson(),
      );
      response = QueryResponse.fromJson(res.data);
      print('fetch data => $response');
    } catch (e) {
      print('REST API ERROR ============================> $e');
    }

    return response;
  }
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation value) {
    print("onAnnotationClick, id: ${value.id}, name: ${value.textField}");
  }
}

// class AnnotationClickListener extends OnCircleAnnotationClickListener {
//   AnnotationClickListener({
//     required this.onAnnotationClick,
//   });
//
//   final void Function(CircleAnnotation annotation) onAnnotationClick;
//
//   @override
//   void onCircleAnnotationClick(CircleAnnotation annotation) {
//     print("onAnnotationClick, id: ${annotation.id}");
//     onAnnotationClick(annotation);
//   }
// }
