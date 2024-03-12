import 'dart:developer';

import 'package:geolocator/geolocator.dart';

Future<void> postLocation() async {
  try {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      log('Location service is disabled');
      await Geolocator.openLocationSettings();
    }
    bool locationPermissionGranted = await _checkLocationPermission();
    if (!locationPermissionGranted) {
      log('Requesting location permission');
      await _requestLocationPermissionAlways();
    }

    Position position = await _getCurrentLocation();
    log('Getting location: $position');
  } catch (e) {
    log('Error getting location: $e');
  }
}

Future<Position> _getCurrentLocation() async {
  log('Getting current location');
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<bool> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  log('Checking location permission$permission');

  return permission == LocationPermission.always;
}

Future<void> _requestLocationPermissionAlways() async {
  log('Requesting location permission');
  await Geolocator.requestPermission();
}
