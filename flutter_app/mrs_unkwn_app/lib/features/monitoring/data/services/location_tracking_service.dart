import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/utils/logger.dart';
import '../models/safe_zone.dart';

/// Tracks device location and checks safe-zone boundaries.
class LocationTrackingService {
  LocationTrackingService();

  static const _historyBox = 'location_history';
  static const _zonesBox = 'safe_zones';
  static bool _initialized = false;

  Box? _history;
  Box? _zones;
  StreamSubscription<Position>? _subscription;
  final Map<String, bool> _zoneStates = {};

  /// Initializes Hive boxes for history and safe zones.
  Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    if (!Hive.isBoxOpen(_historyBox)) {
      _history = await Hive.openBox(_historyBox);
    } else {
      _history = Hive.box(_historyBox);
    }
    if (!Hive.isBoxOpen(_zonesBox)) {
      _zones = await Hive.openBox(_zonesBox);
    } else {
      _zones = Hive.box(_zonesBox);
    }
  }

  /// Starts listening to position changes with 50m distance filter.
  Future<void> start() async {
    await init();
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    if (!await Geolocator.isLocationServiceEnabled()) return;
    _subscription?.cancel();
    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 50),
    ).listen(_onPosition);
  }

  /// Stops location tracking.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  /// Adds a [zone] to the list of safe zones.
  Future<void> addZone(SafeZone zone) async {
    await init();
    await _zones?.put(zone.name, zone.toJson());
    _zoneStates[zone.name] = false;
  }

  /// Removes a safe zone by its [name].
  Future<void> removeZone(String name) async {
    await init();
    await _zones?.delete(name);
    _zoneStates.remove(name);
  }

  /// Returns all configured safe zones.
  Future<List<SafeZone>> zones() async {
    await init();
    return _zones!.values
        .map((e) => SafeZone.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _onPosition(Position pos) async {
    await _history?.add({
      'timestamp': DateTime.now().toIso8601String(),
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
    await cleanup();
    await _checkZones(pos);
  }

  /// Removes history entries older than [maxAge].
  Future<void> cleanup({Duration maxAge = const Duration(days: 30)}) async {
    await init();
    final threshold = DateTime.now().subtract(maxAge);
    final keys = <dynamic>[];
    for (final entry in _history!.toMap().entries) {
      final map = Map<String, dynamic>.from(entry.value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(threshold)) keys.add(entry.key);
    }
    await _history!.deleteAll(keys);
  }

  Future<void> _checkZones(Position pos) async {
    final zonesList = await zones();
    for (final zone in zonesList) {
      final inside = zone.contains(pos);
      final prev = _zoneStates[zone.name] ?? false;
      if (inside && !prev) {
        Logger.info('Entered safe zone ${zone.name}');
      } else if (!inside && prev) {
        Logger.warning('Exited safe zone ${zone.name}');
      }
      _zoneStates[zone.name] = inside;
    }
  }

  /// Returns the current position for emergency sharing.
  Future<Position?> currentPosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }
}
