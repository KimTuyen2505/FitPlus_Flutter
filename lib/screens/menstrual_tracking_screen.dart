import 'package:flutter/material.dart';

class MenstrualTrackingScreen extends StatefulWidget {
  const MenstrualTrackingScreen({super.key});

  @override
  State<MenstrualTrackingScreen> createState() =>
      _MenstrualTrackingScreenState();
}

class _MenstrualTrackingScreenState extends State<MenstrualTrackingScreen> {
  final DateTime _lastPeriodDate = DateTime(2024, 11, 1);
  final int _cycleLength = 28;
  final int _periodLength = 5;

  late DateTime _nextPeriodDate;
  late DateTime _ovulationDate;
  String _currentPhase = 'Kinh nguyệt';

  @override
  void initState() {
    super.initState();
    _calculatePhases();
  }

  void _calculatePhases() {
    _nextPeriodDate = _lastPeriodDate.add(Duration(days: _cycleLength));
    _ovulationDate = _lastPeriodDate.add(Duration(days: _cycleLength ~/ 2));

    int daysSinceLast = DateTime.now().difference(_lastPeriodDate).inDays;
    if (daysSinceLast <= _periodLength) {
      _currentPhase = 'Kinh nguyệt';
    } else if (daysSinceLast <= _cycleLength ~/ 2) {
      _currentPhase = 'Giai đoạn ngoài kinh';
    } else if (daysSinceLast <= _cycleLength ~/ 2 + 5) {
      _currentPhase = 'Giai đoạn rụng trứng';
    } else {
      _currentPhase = 'Sau giai đoạn rụng trứng';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theo dõi chu kỳ kinh nguyệt')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin chu kỳ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCycleInfoRow(
                      'Kỳ kinh cuối cùng',
                      _formatDate(_lastPeriodDate),
                    ),
                    _buildCycleInfoRow(
                      'Kỳ kinh tiếp theo',
                      _formatDate(_nextPeriodDate),
                    ),
                    _buildCycleInfoRow(
                      'Dự đoán rụng trứng',
                      _formatDate(_ovulationDate),
                    ),
                    _buildCycleInfoRow('Giai đoạn hiện tại', _currentPhase),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Lịch theo dõi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
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
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(28, (index) {
                    bool isPeriod = index < _periodLength;
                    bool isOvulation = (index - _cycleLength ~/ 2).abs() <= 2;

                    Color backgroundColor;
                    if (isPeriod) {
                      backgroundColor = Colors.red.withValues(alpha: 0.3);
                    } else if (isOvulation) {
                      backgroundColor = Colors.yellow.withValues(alpha: 0.3);
                    } else {
                      backgroundColor = Colors.blue.withValues(alpha: 0.1);
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Ghi chép',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFlowIntensitySlider(),
                    const SizedBox(height: 16),
                    _buildPainLevelSlider(),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Thông tin đã được lưu'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: const Text('Lưu ghi chép'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCycleInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowIntensitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lượng kinh',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Slider(
          value: 2,
          min: 1,
          max: 5,
          divisions: 4,
          label: ['Rất ít', 'Ít', 'Vừa', 'Nhiều', 'Rất nhiều'][1],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildPainLevelSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mức độ đau bụng',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Slider(
          value: 3,
          min: 1,
          max: 10,
          divisions: 9,
          label: '3/10',
          onChanged: (value) {},
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
