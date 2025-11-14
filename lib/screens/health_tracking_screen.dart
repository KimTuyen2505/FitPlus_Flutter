import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_data_provider.dart';
import '../models/health_record_model.dart';
import 'package:uuid/uuid.dart';

class HealthTrackingScreen extends StatefulWidget {
  const HealthTrackingScreen({Key? key}) : super(key: key);

  @override
  State<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  final _weightController = TextEditingController();
  final _heartRateController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi sức khỏe')),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Lịch sử dữ liệu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (provider.healthRecords.isEmpty)
                  const Center(child: Text('Chưa có dữ liệu'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.healthRecords.length,
                    itemBuilder: (context, index) {
                      final record = provider.healthRecords[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(record.recordDate.toString()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (record.weightKg != null) Text('Cân nặng: ${record.weightKg} kg'),
                              if (record.heartRate != null) Text('Nhịp tim: ${record.heartRate} bpm'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Nhập thông tin mới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cân nặng (kg)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _heartRateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nhịp tim (bpm)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _addHealthRecord(context, provider),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    backgroundColor: Colors.blue.shade600,
                  ),
                  child: const Text('Lưu dữ liệu', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addHealthRecord(BuildContext context, HealthDataProvider provider) {
    final record = HealthRecordModel(
      recordId: const Uuid().v4(),
      userId: 'current_user_id',
      recordDate: DateTime.now(),
      weightKg: double.tryParse(_weightController.text),
      heartRate: int.tryParse(_heartRateController.text),
    );

    provider.addHealthRecord(record).then((success) {
      if (success) {
        _weightController.clear();
        _heartRateController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dữ liệu đã được lưu')),
        );
      }
    });
  }
}
