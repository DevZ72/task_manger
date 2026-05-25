import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'user_profile_screen.dart';
import 'auth_service.dart';

class MainWorkspace extends StatefulWidget {
  const MainWorkspace({super.key});

  @override
  State<MainWorkspace> createState() => _MainWorkspaceState();
}

class _MainWorkspaceState extends State<MainWorkspace> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    const HomeScreen(),        // Week 1-3 Planner App UI
    const UserProfileScreen(), // Week 4 Live Network Parsing App UI
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Task Manager" : "Network Profile Component"),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signOut(), // Logs out from Firebase
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1A237E),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Planner"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_sync), label: "API Consumer"),
        ],
      ),
    );
  }
}