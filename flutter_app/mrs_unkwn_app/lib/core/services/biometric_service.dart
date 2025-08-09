import 'package:local_auth/local_auth.dart';

/// Service wrapper around [LocalAuthentication] for biometric checks.
class BiometricService {
  BiometricService() : _auth = LocalAuthentication();

  final LocalAuthentication _auth;

  /// Returns true if biometrics are available and the device supports them.
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (_) {
      return false;
    }
  }

  /// Returns list of available biometric types on the device.
  Future<List<BiometricType>> getBiometricTypes() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  /// Prompts the user for biometric authentication.
  Future<bool> authenticateWithBiometric() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Bitte biometrisch authentifizieren',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (_) {
      return false;
    }
  }
}
