import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/subject_classification_service.dart';

void main() {
  group('SubjectClassificationService', () {
    test('classifies math question and updates history', () {
      final service = SubjectClassificationService();
      final result = service.classify('How do I solve this equation?');
      expect(result, contains('math'));
      expect(service.history, contains('math'));
      expect(service.subjectSwitched, isFalse);
    });

    test('detects multiple subjects in a question', () {
      final service = SubjectClassificationService();
      final result = service.classify('This experiment uses geometry and chemistry.');
      expect(result, containsAll(<String>['science', 'math']));
      expect(service.subjectSwitched, isFalse);
    });

    test('flags subject switch between consecutive questions', () {
      final service = SubjectClassificationService();
      service.classify('Explain the process of photosynthesis.');
      expect(service.subjectSwitched, isFalse);
      service.classify('Solve the integral of x squared.');
      expect(service.subjectSwitched, isTrue);
    });

    test('classifyWithModel falls back to classify', () async {
      final service = SubjectClassificationService();
      final result = await service.classifyWithModel('Who was the first president of the US?');
      expect(result, contains('history'));
    });

    test('returns unknown when no keyword matches', () {
      final service = SubjectClassificationService();
      final result = service.classify('Please bake a cake.');
      expect(result, contains('unknown'));
    });
  });
}
