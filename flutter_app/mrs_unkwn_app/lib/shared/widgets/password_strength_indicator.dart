import 'package:flutter/material.dart';

/// Displays password strength with color feedback and improvement suggestions.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.password});

  /// The current password input that will be evaluated.
  final String password;

  @override
  Widget build(BuildContext context) {
    final _PasswordEvaluation evaluation = _evaluatePassword(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LinearProgressIndicator(
          value: evaluation.score / 4,
          color: evaluation.color,
          backgroundColor: Colors.grey.shade300,
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Text(
          evaluation.label,
          style: TextStyle(color: evaluation.color, fontSize: 12),
        ),
        if (evaluation.suggestions.isNotEmpty) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            evaluation.suggestions.join(' '),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ],
    );
  }

  _PasswordEvaluation _evaluatePassword(String value) {
    int score = 0;
    final List<String> suggestions = <String>[];

    if (value.length >= 8) {
      score++;
    } else {
      suggestions.add('Mindestens 8 Zeichen verwenden.');
    }
    if (RegExp(r'[a-z]').hasMatch(value) && RegExp(r'[A-Z]').hasMatch(value)) {
      score++;
    } else {
      suggestions.add('Groß- und Kleinbuchstaben kombinieren.');
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      score++;
    } else {
      suggestions.add('Zahlen hinzufügen.');
    }
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
      score++;
    } else {
      suggestions.add('Sonderzeichen nutzen.');
    }

    Color color;
    String label;
    switch (score) {
      case 0:
      case 1:
        color = Colors.red;
        label = 'Schwach';
        break;
      case 2:
        color = Colors.orange;
        label = 'Mittel';
        break;
      default:
        color = Colors.green;
        label = 'Stark';
    }

    return _PasswordEvaluation(score, color, label, suggestions);
  }
}

class _PasswordEvaluation {
  const _PasswordEvaluation(this.score, this.color, this.label, this.suggestions);

  final int score;
  final Color color;
  final String label;
  final List<String> suggestions;
}

