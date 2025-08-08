import 'dart:async';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/services/monitoring_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final monitoring = sl<MonitoringService>();
  await monitoring.init();
  runZonedGuarded(
    () => runApp(const MrsUnkwnApp()),
    (error, stack) => monitoring.recordError(error, stack, fatal: true),
  );
}
