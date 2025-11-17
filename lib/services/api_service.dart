import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/health_record_model.dart';
import '../models/reminder_model.dart';
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';
import '../models/menstrual_cycle_model.dart';
import '../models/medical_record_model.dart';
import '../models/health_advice_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const Map<String, String> demoAccounts = {
    'demo@fitplus.com': 'demo123456',
    'user@example.com': 'password123',
  };

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (demoAccounts.containsKey(email) && demoAccounts[email] == password) {
        return {
          'success': true,
          'token': 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'userId': 'user_${email.split('@')[0]}',
            'fullName': email == 'demo@fitplus.com'
                ? 'Người Dùng Demo'
                : 'Người Dùng Test',
            'email': email,
            'phoneNumber': '0123456789',
            'dateOfBirth': '1990-01-01',
            'gender': 'male',
            'height': 175.0,
            'weight': 70.0,
            'bloodType': 'O+',
            'emergencyContact': 'Gia đình',
          },
        };
      }

      // Gọi API thực nếu backend có sẵn
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('API không phản hồi'),
          );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Đăng nhập thất bại'};
      }
    } catch (e) {
      print('[v0] Lỗi đăng nhập: $e');
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }

  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': fullName,
              'email': email,
              'password': password,
              'phoneNumber': phoneNumber,
              'dateOfBirth': dateOfBirth.toIso8601String().split('T')[0],
              'height': height,
              'weight': weight,
            }),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('API không phản hồi'),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Đăng kí thất bại'};
      }
    } catch (e) {
      print('[v0] Lỗi đăng kí: $e');
      return {'success': false, 'message': 'Lỗi: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/${user.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi cập nhật hồ sơ: $e');
    }
  }

  Future<List<dynamic>> getHealthRecords(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health-records/$userId'),
      );
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy hồ sơ sức khỏe: $e');
    }
  }

  Future<Map<String, dynamic>> addHealthRecord(HealthRecordModel record) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/health-records'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi thêm hồ sơ: $e');
    }
  }

  Future<List<dynamic>> getReminders(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reminders/$userId'));
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy nhắc nhở: $e');
    }
  }

  Future<Map<String, dynamic>> addReminder(ReminderModel reminder) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reminders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reminder.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi thêm nhắc nhở: $e');
    }
  }

  Future<Map<String, dynamic>> deleteReminder(String reminderId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/reminders/$reminderId'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi xóa nhắc nhở: $e');
    }
  }

  Future<List<dynamic>> getDoctors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/doctors'));
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy danh sách bác sĩ: $e');
    }
  }

  Future<List<dynamic>> getAppointments(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/$userId'),
      );
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy lịch khám: $e');
    }
  }

  Future<Map<String, dynamic>> bookAppointment(
    AppointmentModel appointment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointment.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi đặt lịch khám: $e');
    }
  }

  Future<List<dynamic>> getMenstrualCycles(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/menstrual-cycles/$userId'),
      );
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy chu kì kinh nguyệt: $e');
    }
  }

  Future<Map<String, dynamic>> addMenstrualCycle(
    MenstrualCycleModel cycle,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/menstrual-cycles'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cycle.toJson()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Lỗi thêm chu kì: $e');
    }
  }

  Future<List<dynamic>> getMedicalRecords(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/medical-records/$userId'),
      );
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy hồ sơ y tế: $e');
    }
  }

  Future<List<dynamic>> getHealthAdvices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health-advices'));
      return jsonDecode(response.body)['data'] ?? [];
    } catch (e) {
      throw Exception('Lỗi lấy lời khuyên: $e');
    }
  }
}
