import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_data_provider.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  bool _sortByDate = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HealthDataProvider>().loadMedicalRecords('current_user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử y tế'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => setState(() => _sortByDate = !_sortByDate),
          ),
        ],
      ),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          final records = _sortByDate
              ? provider.medicalRecords
              : List.from(provider.medicalRecords)..sort((a, b) => a.diagnosis.compareTo(b.diagnosis));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (records.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('Chưa có hồ sơ y tế'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.diagnosis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Bác sĩ: ${record.doctorName}'),
                              Text('Ngày: ${record.dateCreated.toString().split(' ')[0]}'),
                              const SizedBox(height: 8),
                              Text('Ghi chú: ${record.notes}'),
                              if (record.medications.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Text('Thuốc:'),
                                ...record.medications
                                    .map((med) => Text('• $med'))
                                    .toList(),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
