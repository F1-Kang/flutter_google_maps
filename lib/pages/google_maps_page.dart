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
    final circles = useState<Set<Circle>>({});

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

          // Cập nhật vòng tròn bán kính 5km
          circles.value = {
            Circle(
              circleId: const CircleId('myCircle'),
              // ID duy nhất cho vòng tròn
              center: latLng,
              // Tâm của vòng tròn
              radius: 2000,
              // Bán kính (mét) - 5km
              fillColor: Colors.blue.withOpacity(0.2),
              // Màu tô và độ trong suốt
              strokeColor: Colors.blue,
              // Màu viền
              strokeWidth: 2, // Độ dày viền
            ),
          };

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
              circles: circles.value,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
