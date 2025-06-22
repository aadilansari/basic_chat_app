import 'package:basic_chat_app/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? currentPosition;
  final MapController mapController = MapController();
  List<Polygon> rectangles = [];
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

Future<void> _loadLocation() async {
  try {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      final position = await LocationService().getCurrentLocation();
      final lat = position.latitude;
      final lng = position.longitude;

      if (lat == null || lng == null) {
        print("❌ Location data is null");
        return;
      }

      final latlng = LatLng(lat, lng);
      setState(() {
        currentPosition = latlng;
      });

      _createBoundary(latlng);
      mapController.move(latlng, 15.0); // Zoom to location
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is required to show map")),
      );
    }
  } catch (e) {
    print("❌ Location error: $e");
  }
}


  void _createBoundary(LatLng center) {
    const delta = 0.009; // ~1km lat/lng = ~2km square

    final corners = [
      LatLng(center.latitude - delta, center.longitude - delta),
      LatLng(center.latitude - delta, center.longitude + delta),
      LatLng(center.latitude + delta, center.longitude + delta),
      LatLng(center.latitude + delta, center.longitude - delta),
    ];

    setState(() {
      rectangles = [
        Polygon(
          points: corners,
          color: Colors.blue.withOpacity(0.2),
          borderColor: Colors.blue,
          borderStrokeWidth: 2,
        ),
      ];
      markers = [
       Marker(
  point: center,
  width: 40,
  height: 40,
  child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
),

      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location: Map View')),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentPosition!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.basic_chat_app',
                ),
                PolygonLayer(polygons: rectangles),
                MarkerLayer(markers: markers),
              ],
            ),
    );
  }
}
