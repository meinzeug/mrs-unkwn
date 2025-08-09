import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';

/// Synchronizes collected monitoring data with the backend.
///
/// Data is queued locally using Hive and periodically uploaded
/// in hourly batches. Payloads are compressed and encrypted
/// before being sent. Failed uploads remain in the queue and
/// are retried with exponential backoff.
class MonitoringSyncService {
  MonitoringSyncService(this._dio);

  final DioClient _dio;

  static const _boxName = 'monitoring_sync_queue';
  static bool _initialized = false;

  final ValueNotifier<SyncState> status =
      ValueNotifier<SyncState>(SyncState.idle);

  Box? _box;
  Timer? _timer;

  /// Initializes Hive storage.
  Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  /// Starts periodic synchronization every hour.
  Future<void> start() async {
    await init();
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(hours: 1),
      (_) => sync(),
    );
  }

  /// Stops periodic synchronization.
  Future<void> stop() async {
    _timer?.cancel();
  }

  /// Adds new monitoring record to queue.
  Future<void> enqueue(Map<String, dynamic> record) async {
    await init();
    await _box?.add(record);
  }

  Uint8List _compress(Uint8List data) => Uint8List.fromList(gzip.encode(data));

  Uint8List _encrypt(Uint8List data) {
    // NOTE: This is a placeholder key. In production this
    // should come from a secure source.
    final key = encrypt.Key.fromUtf8('32charssecretkeyforaes256!!!!');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    return Uint8List.fromList(encrypted.bytes);
  }

  /// Uploads queued records to backend. Clears queue on success.
  Future<void> sync() async {
    await init();
    if (_box!.isEmpty) return;
    status.value = SyncState.syncing;
    final data =
        _box!.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    final jsonPayload = jsonEncode(data);
    final compressed = _compress(utf8.encode(jsonPayload));
    final encrypted = _encrypt(compressed);
    final payload = base64Encode(encrypted);

    var attempt = 0;
    while (attempt < 3) {
      try {
        await _dio.post('/monitoring/sync', data: {'payload': payload});
        await _box!.clear();
        status.value = SyncState.success;
        return;
      } catch (e, stack) {
        attempt++;
        if (attempt >= 3) {
          Logger.error('sync failed: $e', e, stack);
          status.value = SyncState.error;
          return;
        }
        await Future.delayed(Duration(seconds: 2 * attempt));
      }
    }
  }
}

enum SyncState { idle, syncing, success, error }
