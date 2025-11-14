import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import '../models/reminder_model.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../models/menstrual_cycle_model.dart';
import '../models/medical_record_model.dart';
import '../models/health_advice_model.dart';
import '../services/api_service.dart';

class HealthDataProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<HealthRecordModel> _healthRecords = [];
  List<ReminderModel> _reminders = [];
  List<DoctorModel> _doctors = [];
  List<AppointmentModel> _appointments = [];
  List<MenstrualCycleModel> _cycles = [];
  List<MedicalRecordModel> _medicalRecords = [];
  List<HealthAdviceModel> _healthAdvices = [];

  List<HealthRecordModel> get healthRecords => _healthRecords;
  List<ReminderModel> get reminders => _reminders;
  List<DoctorModel> get doctors => _doctors;
  List<AppointmentModel> get appointments => _appointments;
  List<MenstrualCycleModel> get cycles => _cycles;
  List<MedicalRecordModel> get medicalRecords => _medicalRecords;
  List<HealthAdviceModel> get healthAdvices => _healthAdvices;

  Future<void> loadHealthRecords(String userId) async {
    try {
      final records = await _apiService.getHealthRecords(userId);
      _healthRecords = records.map((r) => HealthRecordModel.fromJson(r)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải hồ sơ sức khỏe: $e');
    }
  }

  Future<bool> addHealthRecord(HealthRecordModel record) async {
    try {
      final response = await _apiService.addHealthRecord(record);
      if (response['success']) {
        _healthRecords.add(record);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi thêm ghi chép: $e');
      return false;
    }
  }

  Future<void> loadReminders(String userId) async {
    try {
      final reminders = await _apiService.getReminders(userId);
      _reminders = reminders.map((r) => ReminderModel.fromJson(r)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải nhắc nhở: $e');
    }
  }

  Future<bool> addReminder(ReminderModel reminder) async {
    try {
      final response = await _apiService.addReminder(reminder);
      if (response['success']) {
        _reminders.add(reminder);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi thêm nhắc nhở: $e');
      return false;
    }
  }

  Future<bool> deleteReminder(String reminderId) async {
    try {
      final response = await _apiService.deleteReminder(reminderId);
      if (response['success']) {
        _reminders.removeWhere((r) => r.reminderId == reminderId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi xóa nhắc nhở: $e');
      return false;
    }
  }

  Future<void> loadDoctors() async {
    try {
      final doctors = await _apiService.getDoctors();
      _doctors = doctors.map((d) => DoctorModel.fromJson(d)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải danh sách bác sĩ: $e');
    }
  }

  Future<void> loadAppointments(String userId) async {
    try {
      final appointments = await _apiService.getAppointments(userId);
      _appointments = appointments.map((a) => AppointmentModel.fromJson(a)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải lịch khám: $e');
    }
  }

  Future<bool> bookAppointment(AppointmentModel appointment) async {
    try {
      final response = await _apiService.bookAppointment(appointment);
      if (response['success']) {
        _appointments.add(appointment);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi đặt lịch khám: $e');
      return false;
    }
  }

  Future<void> loadMenstrualCycles(String userId) async {
    try {
      final cycles = await _apiService.getMenstrualCycles(userId);
      _cycles = cycles.map((c) => MenstrualCycleModel.fromJson(c)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải chu kì kinh nguyệt: $e');
    }
  }

  Future<bool> addMenstrualCycle(MenstrualCycleModel cycle) async {
    try {
      final response = await _apiService.addMenstrualCycle(cycle);
      if (response['success']) {
        _cycles.add(cycle);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('[v0] Lỗi thêm chu kì: $e');
      return false;
    }
  }

  Future<void> loadMedicalRecords(String userId) async {
    try {
      final records = await _apiService.getMedicalRecords(userId);
      _medicalRecords = records.map((r) => MedicalRecordModel.fromJson(r)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải hồ sơ y tế: $e');
    }
  }

  Future<void> loadHealthAdvices() async {
    try {
      final advices = await _apiService.getHealthAdvices();
      _healthAdvices = advices.map((a) => HealthAdviceModel.fromJson(a)).toList();
      notifyListeners();
    } catch (e) {
      print('[v0] Lỗi tải lời khuyên: $e');
    }
  }
}
