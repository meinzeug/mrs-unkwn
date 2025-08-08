import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('login page golden test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await expectLater(
      find.byType(LoginPage),
      matchesGoldenFile('goldens/login_page.png'),
    );
  });
}
