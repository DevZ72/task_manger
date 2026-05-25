import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple StateProvider from the Riverpod package to manage theme state
final themeModeProvider = StateProvider<bool>((ref) => false); // false = Light Mode, true = Dark Mode