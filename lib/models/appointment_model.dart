class AppointmentModel {
  final String appointmentId;
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final String status;
  final String? notes;

  AppointmentModel({
    required this.appointmentId,
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointmentId'] ?? '',
      userId: json['userId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      appointmentDate: DateTime.parse(json['appointmentDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      notes: json['notes'],
    );
  }
}
