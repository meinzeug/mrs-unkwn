import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:mrs_unkwn_app/core/services/openai_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.openai.com'));
    registerFallbackValue(<String, String>{});
  });

  test('sendChatRequest returns content and tracks usage', () async {
    final client = MockHttpClient();
    when(() =>
        client.post(any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'))).thenAnswer((_) async => http.Response(
        '{"choices":[{"message":{"content":"Hi"}}],"usage":{"total_tokens":7}}',
        200));

    final service = OpenAIService(client: client, wait: (_) async {});
    final result = await service.sendChatRequest(
        'Hello', [ChatMessage(role: 'system', content: 'You are helpful')]);

    expect(result, 'Hi');
    expect(service.requestCount, 1);
    expect(service.totalTokens, 7);
    verify(() => client.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).called(1);
  });

  test('retries on rate limit and succeeds', () async {
    final client = MockHttpClient();
    var call = 0;
    when(() => client.post(any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'))).thenAnswer((_) async {
      call++;
      if (call == 1) {
        return http.Response('rate limit', 429);
      }
      return http.Response(
          '{"choices":[{"message":{"content":"ok"}}],"usage":{"total_tokens":3}}',
          200);
    });

    final service = OpenAIService(client: client, wait: (_) async {});
    final result = await service.sendChatRequest(
        'Hello', [ChatMessage(role: 'system', content: 'ctx')]);

    expect(result, 'ok');
    expect(service.requestCount, 1);
    expect(service.totalTokens, 3);
    verify(() => client.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).called(2);
  });
}
