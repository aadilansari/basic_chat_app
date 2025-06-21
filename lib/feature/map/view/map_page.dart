import 'package:basic_chat_app/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Circle> circles = {};
  Set<Polygon> rectangles = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final position = await LocationService().getCurrentLocation();
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      _createBoundary(position.latitude, position.longitude);
    } catch (e) {
      print("❌ Location error: $e");
    }
  }

  void _createBoundary(double lat, double lng) {
    // Rectangle corners for approx 2km square
    const delta = 0.009; // ~1km latitude/longitude

    final corners = <LatLng>[
      LatLng(lat - delta, lng - delta),
      LatLng(lat - delta, lng + delta),
      LatLng(lat + delta, lng + delta),
      LatLng(lat + delta, lng - delta),
    ];

    setState(() {
      rectangles.add(
        Polygon(
          polygonId: const PolygonId("boundary"),
          points: corners,
          fillColor: Colors.blue.withOpacity(0.1),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      );
    });

    // Optional: add center marker
    markers.add(
      Marker(
        markerId: const MarkerId("me"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(title: "You"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition!,
                zoom: 14,
              ),
              polygons: rectangles,
              markers: markers,
              myLocationEnabled: true,
              onMapCreated: (controller) => mapController = controller,
            ),
    );
  }
}
