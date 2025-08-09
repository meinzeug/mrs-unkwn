import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:mrs_unkwn_app/core/services/openai_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  test('sendChatRequest returns response and tracks usage', () async {
    final client = MockHttpClient();
    final service = OpenAIService(client: client);

    when(() => client.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response(
        jsonEncode({
          'choices': [
            {
              'message': {'content': 'Hello'}
            }
          ],
          'usage': {'total_tokens': 21}
        }),
        200,
      ),
    );

    final result = await service.sendChatRequest('Hi', []);

    expect(result, 'Hello');
    expect(service.requestCount, 1);
    expect(service.totalTokens, 21);

    verify(() => client.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).called(1);
  });
}
