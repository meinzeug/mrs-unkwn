import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

class MrsUnkwnApp extends StatelessWidget {
  const MrsUnkwnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mrs-Unkwn',
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      home: const Placeholder(),
    );
  }
}
