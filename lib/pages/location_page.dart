import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:location/location.dart';

class LocationPage extends HookWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final location = useMemoized(() => Location());
    final locationStream = useStream(location.onLocationChanged);

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
      return null;
    }, [location]);

    if (locationStream.hasData) {
      final data = locationStream.data!;
      print('Latitude => ${data.latitude}');
      print('Longitude => ${data.longitude}');
      return Scaffold(
        appBar: AppBar(title: const Text('Location Hook')),
        body: Center(
          child:
              Text('Latitude: ${data.latitude}, Longitude: ${data.longitude}'),
        ),
      );
    } else if (locationStream.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Location Hook')),
        body: Center(child: Text('Error: ${locationStream.error}')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Location Hook')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
