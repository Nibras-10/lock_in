import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lock_in/providers/habit_provider.dart';
import 'package:lock_in/widgets/common/habit_card.dart';
import 'package:lock_in/config/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lock-In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              final activeHabits = habitProvider.activeHabits;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Habits',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress overview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context, 
                          activeHabits.length.toString(), 
                          'Active Habits'
                        ),
                        _buildStatItem(
                          context,
                          _calculateTotalStreak(activeHabits).toString(),
                          'Total Streak'
                        ),
                        _buildStatItem(
                          context,
                          '${_calculateCompletionRate(habitProvider)}%',
                          'Completion'
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Habits list
                  Expanded(
                    child: activeHabits.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            itemCount: activeHabits.length,
                            itemBuilder: (context, index) {
                              final habit = activeHabits[index];
                              return HabitCard(
                                habit: habit,
                                onTap: () {
                                  // Navigate to habit details
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.habits);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.focus);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.progress);
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add habit screen
          Navigator.pushNamed(context, AppRoutes.habits);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building better habits today',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.habits);
            },
            child: const Text('Add your first habit'),
          ),
        ],
      ),
    );
  }

  int _calculateTotalStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((habit) => habit.currentStreak).reduce((a, b) => a + b);
  }

  int _calculateCompletionRate(HabitProvider provider) {
    final completedToday = provider.activeHabits.where((habit) {
      final today = DateTime.now();
      return habit.completedDates.any((date) => 
        date.year == today.year && 
        date.month == today.month && 
        date.day == today.day);
    }).length;
    
    if (provider.activeHabits.isEmpty) return 0;
    return ((completedToday / provider.activeHabits.length) * 100).round();
  }
}