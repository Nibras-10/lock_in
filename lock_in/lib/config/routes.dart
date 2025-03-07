import 'package:flutter/material.dart';
import 'package:lock_in/screens/home/home_screen.dart';
import 'package:lock_in/screens/habits/habit_screen.dart';
import 'package:lock_in/screens/focus/focus_screen.dart';
import 'package:lock_in/screens/progress/progress_screen.dart';



class AppRoutes {
  static const String home = '/';
  static const String habits = '/habits';
  static const String focus = '/focus';
  static const String progress = '/progress';
  static const String journal = '/journal';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        habits: (context) => const HabitsScreen(),
        focus: (context) => const FocusScreen(),
        progress: (context) => const ProgressScreen(),
        
      };
}