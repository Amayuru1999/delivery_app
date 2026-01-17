import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'models/delivery.dart';
import 'services/api_service.dart';

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
  // Phase 2: Nullable delivery data that will be fetched from API
  Delivery? delivery;
  bool isLoading = true;
  String? errorMessage;

  Position? currentPosition;
  String? locationError;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchDeliveryData();
    _getCurrentLocation();
  }

  /// Fetches delivery data from API
  Future<void> _fetchDeliveryData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.fetchDeliveryData();
      setState(() {
        delivery = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Details"),
        actions: [
          IconButton(
            onPressed: () {
              _fetchDeliveryData();
              _getCurrentLocation();
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh data",
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading delivery data...'),
          ],
        ),
      );
    }

    // Error state
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchDeliveryData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Success state - show delivery data
    if (delivery == null) {
      return const Center(child: Text('No delivery data available'));
    }

    return _buildDeliveryView();
  }

  Widget _buildDeliveryView() {
    final destinationLatLng =
        LatLng(delivery!.destination.latitude, delivery!.destination.longitude);

    final currentLatLng = currentPosition == null
        ? null
        : LatLng(currentPosition!.latitude, currentPosition!.longitude);

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: delivery!.destination.address,
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

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer: ${delivery!.customerName}",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text("Package: ${delivery!.packageDetails}"),
                const SizedBox(height: 6),
                Text("Destination: ${delivery!.destination.address}"),
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
    );
  }
}