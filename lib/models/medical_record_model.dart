class MedicalRecordModel {
  final String recordId;
  final String userId;
  final String diagnosis;
  final DateTime dateCreated;
  final String doctorName;
  final String notes;
  final List<String> medications;

  MedicalRecordModel({
    required this.recordId,
    required this.userId,
    required this.diagnosis,
    required this.dateCreated,
    required this.doctorName,
    required this.notes,
    required this.medications,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'userId': userId,
      'diagnosis': diagnosis,
      'dateCreated': dateCreated.toIso8601String(),
      'doctorName': doctorName,
      'notes': notes,
      'medications': medications,
    };
  }

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      recordId: json['recordId'] ?? '',
      userId: json['userId'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      dateCreated: DateTime.parse(json['dateCreated'] ?? DateTime.now().toIso8601String()),
      doctorName: json['doctorName'] ?? '',
      notes: json['notes'] ?? '',
      medications: List<String>.from(json['medications'] ?? []),
    );
  }
}
