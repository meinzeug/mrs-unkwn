import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/content_moderation_service.dart';

void main() {
  final service = ContentModerationService();

  test('returns clean result for safe text', () {
    final result = service.check('Hello, how are you?');
    expect(result.isClean, true);
    expect(result.categories, isEmpty);
  });

  test('detects profanity', () {
    final result = service.check('This is damn bad');
    expect(result.isClean, false);
    expect(result.categories, contains(ModerationCategory.profanity));
  });

  test('detects multiple categories', () {
    final result = service.check('kill and sex');
    expect(result.isClean, false);
    expect(
      result.categories,
      containsAll([
        ModerationCategory.violence,
        ModerationCategory.adult,
      ]),
    );
  });
}
