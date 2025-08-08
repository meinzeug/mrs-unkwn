import 'dart:collection';

/// Service for determining the subject of a user question.
/// Uses simple keyword matching and keeps a history of
/// detected subjects. A placeholder for a future
/// ML-based classifier is provided.
class SubjectClassificationService {
  SubjectClassificationService();

  final Map<String, List<String>> _keywordMap = {
    'math': [
      'math',
      'equation',
      'calculate',
      'geometry',
      'algebra',
      'fraction',
      'integral',
      'derivative',
    ],
    'science': [
      'science',
      'experiment',
      'physics',
      'chemistry',
      'biology',
      'hypothesis',
      'atom',
      'cell',
    ],
    'literature': [
      'literature',
      'poem',
      'novel',
      'author',
      'story',
      'character',
      'plot',
    ],
    'history': [
      'history',
      'war',
      'revolution',
      'ancient',
      'empire',
      'president',
      'king',
    ],
  };

  final List<String> _history = [];
  String? _currentSubject;
  bool _subjectSwitched = false;

  /// Classifies the given [question] and returns a list of
  /// detected subjects. Multiple subjects may be returned
  /// for multi-topic questions.
  List<String> classify(String question) {
    final lower = question.toLowerCase();
    final Set<String> subjects = {};

    _keywordMap.forEach((subject, keywords) {
      for (final keyword in keywords) {
        if (lower.contains(keyword)) {
          subjects.add(subject);
          break;
        }
      }
    });

    if (subjects.isEmpty) {
      subjects.add('unknown');
    }

    final result = subjects.toList();
    _handleSubjectSwitch(result);
    _updateHistory(result);
    return result;
  }

  void _handleSubjectSwitch(List<String> subjects) {
    _subjectSwitched = false;
    if (subjects.length == 1) {
      final newSubject = subjects.first;
      if (_currentSubject != null && _currentSubject != newSubject) {
        _subjectSwitched = true;
      }
      _currentSubject = newSubject;
    } else {
      _currentSubject = null;
    }
  }

  void _updateHistory(List<String> subjects) {
    _history.addAll(subjects);
  }

  /// Returns an unmodifiable view of the classification history.
  List<String> get history => UnmodifiableListView(_history);

  /// Indicates whether the last classification detected a
  /// switch in subject compared to the previous single-subject
  /// classification.
  bool get subjectSwitched => _subjectSwitched;

  /// Placeholder for future ML-based classification.
  /// Currently falls back to [classify].
  Future<List<String>> classifyWithModel(String question) async {
    // Placeholder: replace with model inference when available.
    return classify(question);
  }
}

