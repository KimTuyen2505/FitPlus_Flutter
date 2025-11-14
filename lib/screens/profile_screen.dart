import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _doctorPhoneController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _medicationsController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _fullNameController = TextEditingController(text: user.fullName);
      _emailController = TextEditingController(text: user.email);
      _addressController = TextEditingController(text: user.address);
      _phoneController = TextEditingController(text: user.phoneNumber);
      _doctorPhoneController = TextEditingController(text: user.doctorPhoneNumber ?? '');
      _medicalHistoryController = TextEditingController(text: user.medicalHistory);
      _medicationsController = TextEditingController(text: user.currentMedications);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _doctorPhoneController.dispose();
    _medicalHistoryController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ cá nhân')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('Không tìm thấy dữ liệu'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                _buildTextField('Họ tên', _fullNameController),
                _buildTextField('Email', _emailController),
                _buildTextField('Ngày sinh: ${user.dateOfBirth.toString().split(' ')[0]}', null, enabled: false),
                _buildTextField('Giới tính', null, initialValue: user.gender, enabled: false),
                _buildTextField('Chiều cao (cm)', null, initialValue: '${user.heightCm}', enabled: false),
                _buildTextField('Cân nặng (kg)', null, initialValue: '${user.weightKg}', enabled: false),
                _buildTextField('Nhóm máu', null, initialValue: user.bloodGroup, enabled: false),
                _buildTextField('Nhịp tim (bpm)', null, initialValue: '${user.heartRate}', enabled: false),
                _buildTextField('Địa chỉ', _addressController),
                _buildTextField('Số điện thoại', _phoneController),
                _buildTextField('SĐT bác sĩ riêng', _doctorPhoneController),
                _buildTextField('Tiền sử bệnh án', _medicalHistoryController, maxLines: 3),
                _buildTextField('Thuốc đang sử dụng', _medicationsController, maxLines: 3),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveProfile(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Lưu thông tin', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _exportProfile(context),
                        child: const Text('Xuất thông tin'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    String? initialValue,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông tin đã được lưu')),
    );
  }

  void _exportProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông tin đã được xuất')),
    );
  }
}
