import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/features/tutoring/presentation/pages/chat_page.dart';

void main() {
  testWidgets('chat page initial golden', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatPage()));
    await expectLater(
      find.byType(ChatPage),
      matchesGoldenFile('goldens/chat_page.png'),
    );
  });
}
