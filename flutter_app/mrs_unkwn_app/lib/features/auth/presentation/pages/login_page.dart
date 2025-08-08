import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit logic will be implemented in future steps
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _validateAndSubmit,
                child: const Text('Login'),
              ),
              TextButton(onPressed: () {}, child: const Text('Registrieren')),
            ],
          ),
        ),
      ),
    );
  }
}
