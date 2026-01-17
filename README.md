# Delivery App

A Flutter-based delivery tracking application built for the Junior Mobile Developer Interview Task.

## Features

### Phase 1 - Basic Delivery App ✅
- Display delivery details (customer, package, destination)
- Google Maps integration with current location
- Destination marker with address information
- Route/polyline visualization between locations
- Location permission handling

### Phase 2 - API Integration ✅
- Fetch delivery data from REST API
- Loading states with progress indicator
- Comprehensive error handling
- Retry mechanism for failed requests
- Refresh functionality

## Setup

### Prerequisites
- Flutter SDK (^3.10.7)
- Google Maps API key (for full functionality)

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. **Configure Google Maps API Key:**
   
   **Get API Key:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing project
   - Enable "Maps SDK for Android" and "Maps SDK for iOS"
   - Create credentials → API Key
   - (Optional) Restrict the API key to your app's package name

   **Add to Android:**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key

   **Add to iOS:**
   - Open `ios/Runner/AppDelegate.swift`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key

4. **Configure API endpoint in `lib/config.dart`:**
```dart
static const String apiBaseUrl = 'YOUR_API_ENDPOINT_HERE';
```

   Or use **demo mode** by setting `demoMode = true` in `lib/services/api_service.dart`

### Running the App

```bash
flutter run
```

## API Configuration

The app expects a JSON response in this format:

```json
{
  "customerName": "John Doe",
  "packageDetails": "Small box - documents",
  "destination": {
    "address": "Colombo Fort",
    "latitude": 6.9344,
    "longitude": 79.8428
  }
}
```

Update the `apiBaseUrl` in `lib/config.dart` to point to your API endpoint.

## Project Structure

```
lib/
├── main.dart           # Main app entry point and UI
├── config.dart         # API configuration
├── models/
│   └── delivery.dart   # Data models
└── services/
    └── api_service.dart # API service layer
```

## Assignment Compliance

This project fulfills all requirements for both Phase 1 and Phase 2 of the Junior Mobile Developer Interview Task, including all optional features.

