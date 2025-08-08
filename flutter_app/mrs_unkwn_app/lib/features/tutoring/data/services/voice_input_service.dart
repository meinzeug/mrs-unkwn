import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Service handling speech-to-text input with basic language detection.
class VoiceInputService {
  VoiceInputService({stt.SpeechToText? speech})
      : _speech = speech ?? stt.SpeechToText();

  final stt.SpeechToText _speech;
  bool _initialized = false;

  /// Initializes the speech recognizer and requests microphone permissions.
  Future<bool> init() async {
    if (_initialized) return true;
    _initialized = await _speech.initialize();
    return _initialized;
  }

  /// Starts listening and forwards recognized words through callbacks.
  Future<void> start({
    required void Function(String) onResult,
    required void Function(double) onSoundLevel,
    required void Function(String) onError,
  }) async {
    final available = await init();
    if (!available) {
      onError('Microphone not available');
      return;
    }
    _speech.listen(
      onResult: (res) => onResult(res.recognizedWords),
      listenMode: stt.ListenMode.dictation,
      onSoundLevelChange: onSoundLevel,
      localeId: await _detectLocale(),
      cancelOnError: true,
      partialResults: false,
    );
  }

  /// Stops the current listening session.
  Future<void> stop() async {
    await _speech.stop();
  }

  Future<String> _detectLocale() async {
    final locale = await _speech.systemLocale();
    final id = locale?.localeId ?? '';
    if (id.contains('de')) return 'de_DE';
    return 'en_US';
  }
}

