import 'package:flutter/foundation.dart';

/// Categories flagged by the content moderator.
enum ModerationCategory {
  profanity,
  violence,
  adult,
}

/// Result returned from a moderation check.
class ModerationResult {
  const ModerationResult({required this.isClean, this.categories = const []});

  final bool isClean;
  final List<ModerationCategory> categories;
}

/// Simple keyword based content moderation.
class ContentModerationService {
  static const Map<ModerationCategory, List<String>> _keywords = {
    ModerationCategory.profanity: [
      'damn',
      'shit',
      'fuck',
      'bitch',
      'ass',
    ],
    ModerationCategory.violence: [
      'kill',
      'weapon',
      'fight',
      'attack',
      'murder',
      'bomb',
    ],
    ModerationCategory.adult: [
      'sex',
      'nude',
      'porn',
      'xxx',
      'adult',
      'erotic',
    ],
  };

  /// Checks [text] and returns a [ModerationResult].
  ModerationResult check(String text) {
    final lower = text.toLowerCase();
    final detected = <ModerationCategory>[];
    _keywords.forEach((category, words) {
      if (words.any(lower.contains)) {
        detected.add(category);
      }
    });
    return ModerationResult(isClean: detected.isEmpty, categories: detected);
  }
}

/// Service to notify parents about moderation events.
class ParentNotificationService {
  Future<void> notify({
    required String message,
    required List<ModerationCategory> categories,
  }) async {
    // Placeholder: integrate with real notification mechanism.
    debugPrint('Parent notified: $message categories: $categories');
  }
}

/// Entry of the moderation log.
class ModerationLogEntry {
  ModerationLogEntry({
    required this.id,
    required this.message,
    required this.categories,
    required this.timestamp,
    this.appealed = false,
  });

  final int id;
  final String message;
  final List<ModerationCategory> categories;
  final DateTime timestamp;
  bool appealed;
}

/// Stores moderation logs and allows appeals.
class ModerationLogService {
  final List<ModerationLogEntry> _entries = [];

  void add(String message, List<ModerationCategory> categories) {
    _entries.add(
      ModerationLogEntry(
        id: _entries.length + 1,
        message: message,
        categories: categories,
        timestamp: DateTime.now(),
      ),
    );
  }

  void appeal(int id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index].appealed = true;
    }
  }

  List<ModerationLogEntry> get entries => List.unmodifiable(_entries);
}

