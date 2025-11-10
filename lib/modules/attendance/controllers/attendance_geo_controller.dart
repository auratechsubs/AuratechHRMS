// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../../services/location_service.dart';
// import '../models/office_location.dart';
//  import 'package:flutter/material.dart';
//
// class AttendanceGeoController extends GetxController {
//   // In-memory office list (multiple allowed)
//   final offices = <OfficeLocation>[].obs;
//
//   // State
//   final nearestOffice = Rx<OfficeLocation?>(null);
//   final distanceM = 0.0.obs;
//   final canCheckIn = false.obs;
//   final loading = false.obs;
//   final locationDenied = false.obs;
//
//   // --- Public API ---
//
//   /// Office add karne ka simple method (Admin UI se ya programmatically)
//   void addOffice({
//     required String id,
//     required String name,
//     required double latitude,
//     required double longitude,
//     int radiusM = 50,
//   }) {
//     offices.add(OfficeLocation(
//       id: id,
//       name: name,
//       latitude: latitude,
//       longitude: longitude,
//       radiusM: radiusM,
//     ));
//   }
//
//   /// Office update (by id)
//   void updateOffice(OfficeLocation updated) {
//     final idx = offices.indexWhere((o) => o.id == updated.id);
//     if (idx != -1) offices[idx] = updated;
//   }
//
//   /// Office delete (by id)
//   void removeOffice(String id) {
//     offices.removeWhere((o) => o.id == id);
//   }
//
//   /// Main: Evaluate + Check-in (geo-fence rule)
//   Future<void> evaluateAndCheckIn() async {
//     if (offices.isEmpty) {
//       Get.snackbar('No Offices', 'Koi office location configured nahi hai.');
//       return;
//     }
//
//     loading.value = true;
//     canCheckIn.value = false;
//     nearestOffice.value = null;
//     distanceM.value = 0;
//     locationDenied.value = false;
//
//     try {
//       final ok = await LocationService.ensurePermission();
//       if (!ok) {
//         locationDenied.value = true;
//         Get.snackbar('Permission Required', 'Location permission/grant zaruri hai.');
//         loading.value = false;
//         return;
//       }
//
//       final pos = await LocationService.getCurrentPosition();
//
//       // Nearest office find
//       OfficeLocation? nearest;
//       double? minDist;
//       for (final o in offices) {
//         final d = LocationService.distanceInMeters(
//           lat1: pos.latitude,
//           lon1: pos.longitude,
//           lat2: o.latitude,
//           lon2: o.longitude,
//         );
//         if (nearest == null || d < (minDist ?? double.infinity)) {
//           nearest = o;
//           minDist = d;
//         }
//       }
//
//       if (nearest == null) {
//         Get.snackbar('No Office', 'Office list empty ya evaluate nahi ho paya.');
//         loading.value = false;
//         return;
//       }
//
//       nearestOffice.value = nearest;
//       distanceM.value = (minDist ?? 999999.0);
//
//       canCheckIn.value = distanceM.value <= nearest.radiusM;
//
//       if (canCheckIn.value) {
//         // Yahin aap apni actual check-in action call kar sakte ho (API hit ya local state)
//         Get.snackbar(
//           'Checked-in',
//           'Within ${nearest.radiusM} m • Distance: ${distanceM.value.toStringAsFixed(1)} m',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       } else {
//         Get.snackbar(
//           'Outside Geofence',
//           'Aap ${nearest.name} se ${distanceM.value.toStringAsFixed(1)} m door hain (limit ${nearest.radiusM} m).',
//           backgroundColor: Colors.red.shade600,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       loading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class OfficeLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int radiusM;

  const OfficeLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.radiusM = 50,
  });
}

class GeoCheckResult {
  final bool allowed;
  final OfficeLocation? office;
  final double distanceM;
  final double accuracyM;
  final String? error;

  const GeoCheckResult({
    required this.allowed,
    required this.office,
    required this.distanceM,
    required this.accuracyM,
    this.error,
  });
}

class AttendanceGeoController extends GetxController {
  final offices = <OfficeLocation>[].obs;

  final nearestOffice = Rx<OfficeLocation?>(null);
  final distanceM = 0.0.obs;
  final accuracyM = 0.0.obs;
  final loading = false.obs;
  final bool useAccuracyBuffer = false; // ← strict
  final int maxBufferM = 0;
  @override
  void onInit() {
    super.onInit();
    if (offices.isEmpty) {
      offices.add(
        const OfficeLocation(
          id: 'Auratech Software',
          name: 'Head Office',
          latitude: 26.8446269,
          longitude: 75.8137197,
          radiusM: 100,
          // 26.8446269,75.8137197
        ),
      );
    }
  }

  void addOffice(OfficeLocation office) => offices.add(office);
  void removeOffice(String id) => offices.removeWhere((o) => o.id == id);

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) return false;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    }
    return true;
  }

  /// Collect multiple fixes for ~3s and pick the best (lowest accuracy).
  Future<Position> _getBestFix() async {
    // try last known first (fast path)
    final last = await Geolocator.getLastKnownPosition();
    Position? best = last;

    // stream a few readings for up to 3 seconds
    final stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,

        // timeLimit: Duration(seconds: 3)
      ),
    );

    final started = DateTime.now();
    await for (final p in stream) {
      if (best == null || p.accuracy < best.accuracy) {
        best = p;
      }
      final elapsed = DateTime.now().difference(started);
      if (elapsed.inMilliseconds > 2500) break; // ~2.5s sampling window
      // optional: break early if we already have very good accuracy (<15m)
      if (p.accuracy <= 15) break;
    }

    // fallback: single shot if still null
    best ??= await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 15),
    );
    return best;
  }

  Future<GeoCheckResult> evaluateForCheckIn() async {
    try {
      loading.value = true;

      if (offices.isEmpty) {
        return const GeoCheckResult(
          allowed: false,
          office: null,
          distanceM: 0,
          accuracyM: 0,
          error: 'Koi office configured nahi hai.',
        );
      }

      final ok = await _ensureLocationPermission();
      if (!ok) {
        return const GeoCheckResult(
          allowed: false,
          office: null,
          distanceM: 0,
          accuracyM: 0,
          error: 'Location permission/service required.',
        );
      }

      final pos = await _getBestFix(); // ← improved
      accuracyM.value = pos.accuracy;

      OfficeLocation? nearest;
      double minDist = double.infinity;

      for (final o in offices) {
        final d = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          o.latitude,
          o.longitude,
        );
        if (d < minDist) {
          minDist = d;
          nearest = o;
        }
      }

      nearestOffice.value = nearest;
      distanceM.value = minDist;

      // accuracy buffer — if GPS says ±X m, allow radius + X
      final buffer = pos.accuracy.isFinite ? pos.accuracy : 0.0;
      final limit = (nearest?.radiusM ?? 50) + buffer;

      //final allowed = nearest != null && minDist <= limit;

      final rawRadius = nearest?.radiusM ?? 50;
      final acc = pos.accuracy.isFinite ? pos.accuracy : 0.0;
      final effectiveLimit = useAccuracyBuffer
          ? rawRadius + acc.clamp(0, maxBufferM).toDouble()
          : rawRadius.toDouble(); // ← strict

      final allowed = nearest != null && minDist <= effectiveLimit;
      return GeoCheckResult(
        allowed: allowed,
        office: nearest,
        distanceM: minDist,
        accuracyM: buffer,
        error: allowed
            ? null
            : 'Aap ${nearest?.name ?? 'office'} se ${minDist.toStringAsFixed(1)} m door '
                  'hain (limit ${nearest?.radiusM ?? 50} m, GPS ±${buffer.toStringAsFixed(0)} m).',
      );
    } catch (e) {
      return GeoCheckResult(
        allowed: false,
        office: null,
        distanceM: 0,
        accuracyM: 0,
        error: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }
}
