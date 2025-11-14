import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<Map<String, dynamic>> reminders = [
    {
      'id': 1,
      'title': 'Uống nước',
      'description': 'Uống 200ml nước',
      'time': '08:00',
      'isCompleted': false,
    },
    {
      'id': 2,
      'title': 'Tập thể dục',
      'description': 'Chạy bộ 30 phút',
      'time': '06:30',
      'isCompleted': true,
    },
    {
      'id': 3,
      'title': 'Uống thuốc',
      'description': 'Uống vitamin C',
      'time': '12:00',
      'isCompleted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhắc nhở thông minh')),
      body: reminders.isEmpty
          ? const Center(child: Text('Không có nhắc nhở nào'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                return _buildReminderCard(reminders[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                reminders[index]['isCompleted'] =
                    !reminders[index]['isCompleted'];
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: reminder['isCompleted']
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: reminder['isCompleted']
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: reminder['isCompleted']
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: reminder['isCompleted']
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reminder['description'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reminder['time'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    reminders.removeAt(index);
                  });
                },
                child: const Icon(Icons.delete, size: 20, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nhắc nhở'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Giờ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.access_time),
              ),
              readOnly: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nhắc nhở đã được thêm')),
              );
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}
