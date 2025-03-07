import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lock_in/models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  
  List<Habit> get habits => _habits;
  List<Habit> get activeHabits => _habits.where((habit) => !habit.isCompleted).toList();
  List<Habit> get completedHabits => _habits.where((habit) => habit.isCompleted).toList();

  HabitProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList('habits') ?? [];
    
    _habits = habitsJson
        .map((habitJson) => Habit.fromJson(jsonDecode(habitJson)))
        .toList();
    
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = _habits
        .map((habit) => jsonEncode(habit.toJson()))
        .toList();
    
    await prefs.setStringList('habits', habitsJson);
  }

  Future<void> addHabit(String title, String description, int targetDays, String color, String icon) async {
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      completedDates: [],
      targetDays: targetDays,
      color: color,
      icon: icon,
    );
    
    _habits.add(habit);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    
    if (index != -1) {
      _habits[index] = updatedHabit;
      await _saveHabits();
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((habit) => habit.id == id);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> markHabitAsCompleted(String id, DateTime date) async {
    final index = _habits.indexWhere((habit) => habit.id == id);
    
    if (index != -1) {
      final habit = _habits[index];
      final completedDates = [...habit.completedDates];
      
      // Check if the date already exists
      final dateExists = completedDates.any((d) => 
        d.year == date.year && d.month == date.month && d.day == date.day);
      
      if (!dateExists) {
        completedDates.add(date);
      }
      
      _habits[index] = habit.copyWith(completedDates: completedDates);
      await _saveHabits();
      notifyListeners();
    }
  }

  Future<void> unmarkHabitAsCompleted(String id, DateTime date) async {
    final index = _habits.indexWhere((habit) => habit.id == id);
    
    if (index != -1) {
      final habit = _habits[index];
      final completedDates = [...habit.completedDates];
      
      completedDates.removeWhere((d) => 
        d.year == date.year && d.month == date.month && d.day == date.day);
      
      _habits[index] = habit.copyWith(completedDates: completedDates);
      await _saveHabits();
      notifyListeners();
    }
  }
}