import 'package:flutter/material.dart';
import 'package:lock_in/models/habit.dart';
import 'package:provider/provider.dart';
import 'package:lock_in/providers/habit_provider.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitCard({
    Key? key,
    required this.habit,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isCompletedToday = habit.completedDates.any((date) => 
      date.year == today.year && 
      date.month == today.month && 
      date.day == today.day);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(int.parse(habit.color)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      IconData(
                        int.parse(habit.icon),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${habit.currentStreak} day streak',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isCompletedToday,
                    onChanged: (value) {
                      if (value == true) {
                        context.read<HabitProvider>().markHabitAsCompleted(
                          habit.id,
                          today,
                        );
                      } else {
                        context.read<HabitProvider>().unmarkHabitAsCompleted(
                          habit.id,
                          today,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: habit.progress,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              const SizedBox(height: 8),
              Text(
                '${habit.completedDates.length}/${habit.targetDays} days completed',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}