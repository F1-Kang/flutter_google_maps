import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapsPage extends HookWidget {
  const GoogleMapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = useState<GoogleMapController?>(null);
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

      // Lắng nghe các thay đổi vị trí từ location package
      location.onLocationChanged.listen((LocationData currentLocationData) {
        if (currentLocationData.latitude != null &&
            currentLocationData.longitude != null) {
          final latLng = LatLng(
            currentLocationData.latitude!,
            currentLocationData.longitude!,
          );
          currentLocation.value = latLng;
          // Di chuyển camera đến vị trí mới (nếu muốn)
          mapController.value?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 15.0,
              ),
            ),
          );
        }
      });

      return null;
    }, [location]);

    return Scaffold(
      body: currentLocation.value == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController.value = controller;
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation.value!,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('current_location'),
                  position: currentLocation.value!,
                  infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
