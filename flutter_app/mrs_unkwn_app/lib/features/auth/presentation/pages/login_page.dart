import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../../../../core/routing/route_constants.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/biometric_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _biometricAvailable = false;
  late final BiometricService _biometric;

  @override
  void initState() {
    super.initState();
    _biometric = sl<BiometricService>();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final available = await _biometric.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
      });
    }
  }

  Future<void> _loginWithBiometric() async {
    final success = await _biometric.authenticateWithBiometric();
    if (!mounted) return;
    if (success) {
      context.read<AuthBloc>().add(AuthStatusChanged(const User(id: 'biometric')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrische Authentifizierung fehlgeschlagen')),
      );
    }
  }

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit logic will be implemented in future steps
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(RouteConstants.home);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(height: 150, width: 150, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Willkommen bei Mrs-Unkwn'),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Email eingeben';
                      }
                      final emailRegex = RegExp(
                        r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Ungültiges Email-Format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte Passwort eingeben';
                      }
                      if (value.length < 6) {
                        return 'Mindestens 6 Zeichen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _validateAndSubmit,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Login'),
                  ),
                  if (_biometricAvailable) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _loginWithBiometric,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Biometrisch einloggen'),
                    ),
                  ],
                  TextButton(
                    onPressed: () {},
                    child: const Text('Registrieren'),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteConstants.forgotPassword),
                    child: const Text('Passwort vergessen?'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
