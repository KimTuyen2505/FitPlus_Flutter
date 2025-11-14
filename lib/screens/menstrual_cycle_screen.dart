import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/health_data_provider.dart';
import '../models/menstrual_cycle_model.dart';
import 'package:uuid/uuid.dart';

class MenstrualCycleScreen extends StatefulWidget {
  const MenstrualCycleScreen({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleScreen> createState() => _MenstrualCycleScreenState();
}

class _MenstrualCycleScreenState extends State<MenstrualCycleScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi chu kì kinh nguyệt')),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin chu kì',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (provider.cycles.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Chu kì: ${provider.cycles.last.cycleLengthDays} ngày'),
                            Text('Kỳ kinh: ${provider.cycles.last.periodLengthDays} ngày'),
                            Text('Kỳ kinh tiếp theo: ${provider.cycles.last.nextPeriodDate.toString().split(' ')[0]}'),
                          ],
                        )
                      else
                        const Text('Chưa có dữ liệu chu kì'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showAddCycleDialog(context, provider),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    backgroundColor: Colors.pink.shade600,
                  ),
                  child: const Text('Thêm chu kì', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddCycleDialog(BuildContext context, HealthDataProvider provider) {
    final flowIntensityController = TextEditingController();
    final painLevelController = TextEditingController();
    final symptomsController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ghi nhận chu kì'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: flowIntensityController,
                decoration: const InputDecoration(labelText: 'Lượng kinh (nhẹ/bình thường/nhiều)'),
              ),
              TextField(
                controller: painLevelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mức độ đau (0-10)'),
              ),
              TextField(
                controller: symptomsController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Triệu chứng'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              final cycle = MenstrualCycleModel(
                cycleId: const Uuid().v4(),
                userId: 'current_user_id',
                startDate: _selectedDay,
                cycleLengthDays: 28,
                periodLengthDays: 5,
                flowIntensity: flowIntensityController.text,
                painLevel: int.tryParse(painLevelController.text) ?? 0,
                symptoms: symptomsController.text,
              );
              provider.addMenstrualCycle(cycle).then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chu kì đã được ghi nhận')),
                );
              });
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
