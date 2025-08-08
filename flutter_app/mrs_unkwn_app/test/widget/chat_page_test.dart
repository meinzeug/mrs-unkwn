import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/features/tutoring/presentation/pages/chat_page.dart';

void main() {
  testWidgets('sends user message and receives AI response', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatPage()));

    await tester.enterText(find.byType(TextField), 'Hallo');
    await tester.tap(find.byIcon(Icons.send));

    await tester.pump();
    expect(find.text('Hallo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('AI response to: Hallo'), findsOneWidget);
  });
}
