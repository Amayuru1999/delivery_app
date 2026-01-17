class Delivery {
  final String customerName;
  final String packageDetails;
  final Destination destination;

  Delivery({
    required this.customerName,
    required this.packageDetails,
    required this.destination,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      customerName: json['customerName'] as String,
      packageDetails: json['packageDetails'] as String,
      destination: Destination.fromJson(json['destination'] as Map<String, dynamic>),
    );
  }
}

class Destination {
  final String address;
  final double latitude;
  final double longitude;

  Destination({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}