/// API Configuration
/// Update this URL with your actual API endpoint
class ApiConfig {
  // TEMPORARY: Using a placeholder URL - this will show error state
  // To test the success state, create a mock API at https://designer.mocky.io/
  // with the JSON format from README.md and update this URL
  static const String apiBaseUrl = 'https://jsonkeeper.com/b/4IOUO';
  
  // Timeout duration for API requests
  static const Duration requestTimeout = Duration(seconds: 10);
}
