import 'package:flutter/foundation.dart';

@immutable
class Achievement {
  final String id;
  final String title;
  final String description;
  final bool achieved;
  final DateTime? achievedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.achieved = false,
    this.achievedAt,
  });

  Achievement copyWith({
    bool? achieved,
    DateTime? achievedAt,
  }) =>
      Achievement(
        id: id,
        title: title,
        description: description,
        achieved: achieved ?? this.achieved,
        achievedAt: achievedAt ?? this.achievedAt,
      );
}
