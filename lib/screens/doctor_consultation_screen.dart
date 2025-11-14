import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_data_provider.dart';
import '../models/appointment_model.dart';
import 'package:uuid/uuid.dart';

class DoctorConsultationScreen extends StatefulWidget {
  const DoctorConsultationScreen({Key? key}) : super(key: key);

  @override
  State<DoctorConsultationScreen> createState() => _DoctorConsultationScreenState();
}

class _DoctorConsultationScreenState extends State<DoctorConsultationScreen> {
  String? _selectedDoctorId;
  DateTime? _selectedAppointmentDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HealthDataProvider>().loadDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tư vấn bác sĩ')),
      body: Consumer<HealthDataProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Danh sách bác sĩ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (provider.doctors.isEmpty)
                  const Center(child: Text('Đang tải danh sách bác sĩ...'))
                else
                  Column(
                    children: provider.doctors.map((doctor) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(Icons.person),
                          ),
                          title: Text(doctor.fullName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Chuyên khoa: ${doctor.specialty}'),
                              Text('⭐ ${doctor.rating.toStringAsFixed(1)}'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _selectDoctor(doctor.doctorId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedDoctorId == doctor.doctorId
                                  ? Colors.green
                                  : Colors.blue.shade600,
                            ),
                            child: const Text(
                              'Chọn',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 24),
                if (_selectedDoctorId != null) ...[
                  const Text(
                    'Đặt lịch khám',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _pickAppointmentDate(context),
                    child: Text(_selectedAppointmentDate == null
                        ? 'Chọn ngày giờ'
                        : 'Ngày giờ: ${_selectedAppointmentDate.toString()}'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _bookAppointment(context, provider),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Đặt lịch', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectDoctor(String doctorId) {
    setState(() => _selectedDoctorId = doctorId);
  }

  void _pickAppointmentDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
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
          _selectedAppointmentDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _bookAppointment(BuildContext context, HealthDataProvider provider) {
    if (_selectedDoctorId == null || _selectedAppointmentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn bác sĩ và thời gian')),
      );
      return;
    }

    final appointment = AppointmentModel(
      appointmentId: const Uuid().v4(),
      userId: 'current_user_id',
      doctorId: _selectedDoctorId!,
      appointmentDate: _selectedAppointmentDate!,
      status: 'pending',
    );

    provider.bookAppointment(appointment).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lịch khám đã được đặt')),
        );
        Navigator.pop(context);
      }
    });
  }
}
