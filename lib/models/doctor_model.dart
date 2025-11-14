class DoctorModel {
  final String doctorId;
  final String fullName;
  final String specialty;
  final String phoneNumber;
  final String qualification;
  final double rating;
  final String profileImageUrl;

  DoctorModel({
    required this.doctorId,
    required this.fullName,
    required this.specialty,
    required this.phoneNumber,
    required this.qualification,
    required this.rating,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'fullName': fullName,
      'specialty': specialty,
      'phoneNumber': phoneNumber,
      'qualification': qualification,
      'rating': rating,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['doctorId'] ?? '',
      fullName: json['fullName'] ?? '',
      specialty: json['specialty'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      qualification: json['qualification'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
