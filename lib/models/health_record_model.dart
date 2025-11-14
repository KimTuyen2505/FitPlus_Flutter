class HealthRecordModel {
  final String recordId;
  final String userId;
  final DateTime recordDate;
  final double? weightKg;
  final double? heightCm;
  final int? heartRate;
  final String? notes;

  HealthRecordModel({
    required this.recordId,
    required this.userId,
    required this.recordDate,
    this.weightKg,
    this.heightCm,
    this.heartRate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'userId': userId,
      'recordDate': recordDate.toIso8601String(),
      'weightKg': weightKg,
      'heightCm': heightCm,
      'heartRate': heartRate,
      'notes': notes,
    };
  }

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      recordId: json['recordId'] ?? '',
      userId: json['userId'] ?? '',
      recordDate: DateTime.parse(json['recordDate'] ?? DateTime.now().toIso8601String()),
      weightKg: json['weightKg']?.toDouble(),
      heightCm: json['heightCm']?.toDouble(),
      heartRate: json['heartRate'],
      notes: json['notes'],
    );
  }
}
