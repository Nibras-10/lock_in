// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lock_in/providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _targetDays = 21;
  String _selectedColor = '0xFF6200EE'; // Default color
  String _selectedIcon = '57680'; // Default icon code

  final List<String> _colorOptions = [
    '0xFF6200EE', // Purple
    '0xFF03DAC5', // Teal
    '0xFF018786', // Dark Teal
    '0xFFCF6679', // Pink
    '0xFF4CAF50', // Green
    '0xFF2196F3', // Blue
    '0xFFFF9800', // Orange
    '0xFFE91E63', // Pink
  ];

  final List<IconData> _iconOptions = [
    Icons.fitness_center,
    Icons.water_drop,
    Icons.book,
    Icons.bedtime,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.emoji_food_beverage,
    Icons.menu_book,
    Icons.credit_card_off,
    Icons.no_drinks,
    Icons.language,
    Icons.palette,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Habit Title',
                  hintText: 'e.g., Drink Water',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'e.g., Drink 8 glasses of water daily',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Target Days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How many days do you want to build this habit? Experts suggest 21 days to form a new habit.',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _targetDays.toDouble(),
                min: 7,
                max: 90,
                divisions: 83,
                label: _targetDays.toString(),
                onChanged: (value) {
                  setState(() {
                    _targetDays = value.round();
                  });
                },
              ),
              Text(
                '$_targetDays days',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _colorOptions.map((color) {
                  final colorValue = Color(int.parse(color));
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorValue,
                        shape: BoxShape.circle,
                        border: _selectedColor == color
                            ? Border.all(
                                color: Colors.black,
                                width: 2,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Icon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _iconOptions.map((iconData) {
                  final iconCode = iconData.codePoint.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconCode;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedIcon == iconCode
                            ? Color(int.parse(_selectedColor)).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _selectedIcon == iconCode
                            ? Border.all(
                                color: Color(int.parse(_selectedColor)),
                                width: 2,
                              )
                            : Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                      ),
                      child: Icon(
                        iconData,
                        color: _selectedIcon == iconCode
                            ? Color(int.parse(_selectedColor))
                            : Theme.of(context).iconTheme.color,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  child: const Text('Save Habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      
      habitProvider.addHabit(
        _titleController.text,
        _descriptionController.text,
        _targetDays,
        _selectedColor,
        _selectedIcon,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Habit created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }
}