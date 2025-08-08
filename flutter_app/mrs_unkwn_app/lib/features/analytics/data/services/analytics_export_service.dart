import '../models/learning_report.dart';

/// Converts analytics reports into exportable formats.
class AnalyticsExportService {
  /// Generates a simple CSV representation of a [LearningReport].
  String generateCsv(LearningReport report) {
    final buffer = StringBuffer();
    buffer.writeln('Subject,Minutes');
    report.metrics.timePerSubject.forEach((subject, duration) {
      buffer.writeln('$subject,${duration.inMinutes}');
    });
    buffer.writeln('LearningVelocity,${report.metrics.learningVelocity}');
    return buffer.toString();
  }
}
