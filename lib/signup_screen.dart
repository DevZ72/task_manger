import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _serverErrorMessage;

  void _submitSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _serverErrorMessage = null;
      });

      String? error = await _authService.registerWithEmailAndPassword(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (error != null) {
          setState(() => _serverErrorMessage = error);
        } else {
          // Registration automatically triggers state change handled by auth wrapper
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(title: const Text("Create Account"), backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join Us", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                const SizedBox(height: 25),
                if (_serverErrorMessage != null) ...[
                  Text(_serverErrorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                ],
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (val) => val == null || val.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email Address", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (val) => val != null && val.contains('@') ? null : "Enter a valid email",
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (val) => val != null && val.length >= 6 ? null : "Password must be at least 6 characters",
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3949AB),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}