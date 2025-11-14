class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final DateTime dateOfBirth;
  final String gender;
  final double heightCm;
  final double weightKg;
  final String bloodGroup;
  final int heartRate;
  final String address;
  final String phoneNumber;
  final String? doctorPhoneNumber;
  final String medicalHistory;
  final String currentMedications;
  final String profileImageUrl;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.bloodGroup,
    required this.heartRate,
    required this.address,
    required this.phoneNumber,
    this.doctorPhoneNumber,
    required this.medicalHistory,
    required this.currentMedications,
    required this.profileImageUrl,
  });

  // Tính chỉ số BMI
  double get bmi => weightKg / ((heightCm / 100) * (heightCm / 100));

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'bloodGroup': bloodGroup,
      'heartRate': heartRate,
      'address': address,
      'phoneNumber': phoneNumber,
      'doctorPhoneNumber': doctorPhoneNumber,
      'medicalHistory': medicalHistory,
      'currentMedications': currentMedications,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? '',
      heightCm: (json['heightCm'] ?? 0).toDouble(),
      weightKg: (json['weightKg'] ?? 0).toDouble(),
      bloodGroup: json['bloodGroup'] ?? '',
      heartRate: json['heartRate'] ?? 0,
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      doctorPhoneNumber: json['doctorPhoneNumber'],
      medicalHistory: json['medicalHistory'] ?? '',
      currentMedications: json['currentMedications'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
