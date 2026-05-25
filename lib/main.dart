import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart' as legacy_provider; // Multi-provider prefix
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod implementation
import 'firebase_options.dart';
import 'auth_service.dart';
import 'login_screen.dart';
import 'main_workspace.dart';
import 'task_provider.dart';
import 'theme_provider.dart';
import 'notification_service.dart'; // Import push notification service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Week 5: Configure and initialize the native Firebase SDK core hooks
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Bonus Challenge: Fire up the push notification registration engine
  await NotificationService().initializeNotificationFramework();

  // Bonus Challenge: Wrap application tree inside Riverpod's ProviderScope
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the Advanced Riverpod theme state configuration
    final isDarkMode = ref.watch(themeModeProvider);

    // Week 6: Injecting classic Provider state architecture at root level
    return legacy_provider.MultiProvider(
      providers: [
        legacy_provider.ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Integrated Project Cycle 2',

        // Dynamically toggle themes on the fly across screens using Riverpod state
        theme: ThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),

        // Week 5: Secure Session Stream handling Login vs Authenticated workspace navigation
        home: StreamBuilder(
          stream: AuthService().userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData) {
              return const MainWorkspace();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}