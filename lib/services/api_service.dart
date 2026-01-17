import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/delivery.dart';
import '../config.dart';

class ApiService {
  /// Fetches delivery data from the API
  /// Throws an Exception if the request fails
  Future<Delivery> fetchDeliveryData() async {
    // DEMO MODE: Set this to true to test without a real API
    const bool demoMode = true;
    
    if (demoMode) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return the sample data from the assignment
      final mockData = {
        "customerName": "John Doe",
        "packageDetails": "Small box - documents",
        "destination": {
          "address": "Colombo Fort",
          "latitude": 6.9344,
          "longitude": 79.8428
        }
      };
      
      return Delivery.fromJson(mockData);
    }
    
    // Real API mode (when demoMode is false)
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.apiBaseUrl))
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return Delivery.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load delivery data. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch delivery data: $e');
    }
  }
}
