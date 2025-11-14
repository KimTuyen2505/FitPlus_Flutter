import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_data_provider.dart';

class HealthAdviceScreen extends StatefulWidget {
  const HealthAdviceScreen({Key? key}) : super(key: key);

  @override
  State<HealthAdviceScreen> createState() => _HealthAdviceScreenState();
}

class _HealthAdviceScreenState extends State<HealthAdviceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HealthDataProvider>().loadHealthAdvices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lời khuyên sức khỏe')),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (provider.healthAdvices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('Đang tải lời khuyên...'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.healthAdvices.length,
                    itemBuilder: (context, index) {
                      final advice = provider.healthAdvices[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                advice.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Bộ phận: ${advice.bodyPart}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(advice.content),
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
