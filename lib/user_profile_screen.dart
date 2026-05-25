import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Bonus Challenge
import 'theme_provider.dart'; // Bonus Challenge

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Week 4: HTTP Request, Parsing, and Error Handling
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Fetching from the official assignment-recommended JSONPlaceholder API
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        setState(() {
          _userData = decodedData;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not sync with the server. Please check your connection and retry.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Week 4: Loading Indicator State
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3949AB)),
        ),
      );
    }

    // Week 4: Error Handling UI State
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, color: Colors.redAccent, size: 70),
              const SizedBox(height: 15),
              Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _fetchUserData,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text("Retry Connection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        ),
      );
    }

    // Week 4: Displaying User Data (Name, Email, details)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF3949AB),
              child: Text(
                (_userData?['name'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF1A237E)),
                      title: const Text("Full Name", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      subtitle: Text(_userData?['name'] ?? 'N/A', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 20),
                    ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF1A237E)),
                      title: const Text("Email Address", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      subtitle: Text(_userData?['email'] ?? 'N/A', style: const TextStyle(fontSize: 16)),
                    ),
                    const Divider(height: 20),
                    ListTile(
                      leading: const Icon(Icons.location_city, color: Color(0xFF1A237E)),
                      title: const Text("Company Name", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      subtitle: Text(_userData?['company']?['name'] ?? 'N/A', style: const TextStyle(fontSize: 16)),
                    ),

                    // Bonus Challenge: Advanced State Explorer (Riverpod Theme Toggle Switch)
                    const Divider(height: 20),
                    ListTile(
                      leading: const Icon(Icons.palette, color: Color(0xFF1A237E)),
                      title: const Text("Advanced State (Riverpod)", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      subtitle: const Text("Toggle Dark Mode", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      trailing: Switch(
                        value: ref.watch(themeModeProvider), // Watches Riverpod theme state
                        onChanged: (value) {
                          ref.read(themeModeProvider.notifier).state = value; // Updates Riverpod state
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}