import 'package:flutter/material.dart';
import 'package:lock_in/app.dart';
import 'package:provider/provider.dart';
import 'package:lock_in/providers/habit_provider.dart';
import 'package:lock_in/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: const LockInApp(),
    ),
  );
}