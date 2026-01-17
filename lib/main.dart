import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'models/delivery.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      theme: ThemeData(useMaterial3: true),
      home: const DeliveryScreen(),
    );
  }
}

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  // Hardcoded Phase 1 data
  final Delivery delivery = Delivery(
    customerName: "John Doe",
    packageDetails: "Small box - documents",
    destination: Destination(
      address: "Colombo Fort",
      latitude: 6.9344,
      longitude: 79.8428,
    ),
  );

  Position? currentPosition;
  String? locationError;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        setState(() => locationError = "Location services are disabled.");
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() => locationError = "Location permission denied.");
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => locationError = "Location permission permanently denied.");
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = pos;
        locationError = null;
      });
    } catch (e) {
      setState(() => locationError = "Failed to get location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinationLatLng =
        LatLng(delivery.destination.latitude, delivery.destination.longitude);

    final currentLatLng = currentPosition == null
        ? null
        : LatLng(currentPosition!.latitude, currentPosition!.longitude);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: delivery.destination.address,
        ),
      ),
      if (currentLatLng != null)
        Marker(
          markerId: const MarkerId('current'),
          position: currentLatLng,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
    };

    final polylines = <Polyline>{
      if (currentLatLng != null)
        Polyline(
          polylineId: const PolylineId('route'),
          points: [currentLatLng, destinationLatLng],
          width: 5,
        ),
    };

    final initialTarget = currentLatLng ?? destinationLatLng;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Details"),
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
            tooltip: "Refresh location",
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer: ${delivery.customerName}",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text("Package: ${delivery.packageDetails}"),
                  const SizedBox(height: 6),
                  Text("Destination: ${delivery.destination.address}"),
                ],
              ),
            ),
          ),
          if (locationError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(locationError!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: initialTarget, zoom: 13),
              myLocationEnabled: currentLatLng != null,
              myLocationButtonEnabled: false,
              markers: markers,
              polylines: polylines,
            ),
          ),
        ],
      ),
    );
  }
}