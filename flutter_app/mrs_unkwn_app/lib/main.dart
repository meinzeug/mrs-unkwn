import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/service_locator.dart';

Future<void> main() async {
  await configureDependencies();
  runApp(const MrsUnkwnApp());
}
