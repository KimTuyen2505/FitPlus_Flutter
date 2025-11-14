import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_data_provider.dart';
import '../models/reminder_model.dart';
import 'package:uuid/uuid.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhắc nhở thông minh')),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (provider.reminders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('Chưa có nhắc nhở nào'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = provider.reminders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(reminder.title),
                          subtitle: Text(reminder.reminderDateTime.toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteReminder(context, provider, reminder.reminderId),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Thêm nhắc nhở mới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _pickDateTime(context),
                  child: Text(_selectedDateTime == null
                      ? 'Chọn thời gian'
                      : 'Thời gian: ${_selectedDateTime.toString()}'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _addReminder(context, provider),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    backgroundColor: Colors.blue.shade600,
                  ),
                  child: const Text('Thêm nhắc nhở', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  void _addReminder(BuildContext context, HealthDataProvider provider) {
    if (_titleController.text.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    final reminder = ReminderModel(
      reminderId: const Uuid().v4(),
      userId: 'current_user_id',
      title: _titleController.text,
      description: _descriptionController.text,
      reminderDateTime: _selectedDateTime!,
      isCompleted: false,
    );

    provider.addReminder(reminder).then((success) {
      if (success) {
        _titleController.clear();
        _descriptionController.clear();
        setState(() => _selectedDateTime = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nhắc nhở đã được thêm')),
        );
      }
    });
  }

  void _deleteReminder(BuildContext context, HealthDataProvider provider, String reminderId) {
    provider.deleteReminder(reminderId).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nhắc nhở đã được xóa')),
        );
      }
    });
  }
}
