class Habit {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<DateTime> completedDates;
  final int targetDays;
  final String color;
  final String icon;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.completedDates,
    required this.targetDays,
    required this.color,
    required this.icon,
  });

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    
    final sortedDates = [...completedDates]..sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    
    if (sortedDates.isEmpty) return 0;
    
    final latestDate = DateTime(
      sortedDates[0].year,
      sortedDates[0].month,
      sortedDates[0].day,
    );
    
    // If the latest completed date is not today or yesterday, streak is broken
    if (!(isSameDay(latestDate, today) || isSameDay(latestDate, yesterday))) {
      return 0;
    }
    
    int streak = 1;
    DateTime currentDate = latestDate;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final previousDate = DateTime(
        sortedDates[i].year,
        sortedDates[i].month,
        sortedDates[i].day,
      );
      
      final difference = currentDate.difference(previousDate).inDays;
      
      if (difference == 1) {
        streak++;
        currentDate = previousDate;
      } else if (difference > 1) {
        break;
      }
    }
    
    return streak;
  }
  
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  double get progress {
    return completedDates.length / targetDays;
  }

  bool get isCompleted {
    return completedDates.length >= targetDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'targetDays': targetDays,
      'color': color,
      'icon': icon,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      completedDates: (json['completedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
      targetDays: json['targetDays'],
      color: json['color'],
      icon: json['icon'],
    );
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    List<DateTime>? completedDates,
    int? targetDays,
    String? color,
    String? icon,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
      targetDays: targetDays ?? this.targetDays,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}