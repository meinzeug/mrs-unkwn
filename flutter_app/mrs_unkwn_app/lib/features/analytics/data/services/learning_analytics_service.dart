import '../../../tutoring/data/models/learning_session.dart';
import '../models/achievement.dart';
import '../models/learning_metrics.dart';
import '../models/learning_report.dart';

/// Service that aggregates learning sessions and produces analytics.
class LearningAnalyticsService {
  final List<LearningSession> _sessions = [];
  final List<Achievement> _achievements = [
    const Achievement(
      id: 'curious_learner',
      title: 'Curious Learner',
      description: 'Ask 10 questions in total.',
    ),
    const Achievement(
      id: 'time_master',
      title: 'Time Master',
      description: 'Spend 60 minutes learning.',
    ),
  ];

  void trackSession(LearningSession session) {
    _sessions.add(session);
    _updateAchievements();
  }

  LearningMetrics computeMetrics() {
    final timePerSubject = <String, Duration>{};
    final questionsPerSession = <String, int>{};
    int totalQuestions = 0;
    Duration totalDuration = Duration.zero;

    for (final session in _sessions) {
      for (final topic in session.topics) {
        timePerSubject[topic] =
            (timePerSubject[topic] ?? Duration.zero) + session.duration;
      }
      questionsPerSession[session.id] = session.questionCount;
      totalQuestions += session.questionCount;
      totalDuration += session.duration;
    }

    final velocity = totalDuration.inMinutes == 0
        ? 0.0
        : totalQuestions / totalDuration.inMinutes;

    return LearningMetrics(
      timePerSubject: timePerSubject,
      questionsPerSession: questionsPerSession,
      learningVelocity: velocity,
    );
  }

  void _updateAchievements() {
    final metrics = computeMetrics();
    final totalQuestions =
        metrics.questionsPerSession.values.fold<int>(0, (a, b) => a + b);
    final totalMinutes = metrics.timePerSubject.values
        .fold<Duration>(Duration.zero, (a, b) => a + b)
        .inMinutes;

    for (var i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];
      if (!achievement.achieved) {
        if (achievement.id == 'curious_learner' && totalQuestions >= 10) {
          _achievements[i] = achievement.copyWith(
            achieved: true,
            achievedAt: DateTime.now(),
          );
        } else if (achievement.id == 'time_master' && totalMinutes >= 60) {
          _achievements[i] = achievement.copyWith(
            achieved: true,
            achievedAt: DateTime.now(),
          );
        }
      }
    }
  }

  LearningReport generateReport() {
    final metrics = computeMetrics();
    final achieved = _achievements.where((a) => a.achieved).toList();
    final recommendations = _buildRecommendations(metrics);
    return LearningReport(
      metrics: metrics,
      achievements: achieved,
      recommendations: recommendations,
    );
  }

  String _buildRecommendations(LearningMetrics metrics) {
    if (metrics.learningVelocity < 1) {
      return 'Try asking more questions to speed up learning.';
    }
    return 'Great progress! Keep it up.';
  }
}
