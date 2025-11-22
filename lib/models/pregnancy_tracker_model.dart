class PregnancyTrackerModel {
  final String pregnancyId;
  final String userId;
  final DateTime lastMenstrualDate;
  final String babyName;
  final DateTime expectedDeliveryDate;
  final int weekOfPregnancy;

  PregnancyTrackerModel({
    required this.pregnancyId,
    required this.userId,
    required this.lastMenstrualDate,
    required this.babyName,
    required this.expectedDeliveryDate,
    required this.weekOfPregnancy,
  });

  Map<String, dynamic> toJson() {
    return {
      'pregnancyId': pregnancyId,
      'userId': userId,
      'lastMenstrualDate': lastMenstrualDate.toIso8601String(),
      'babyName': babyName,
      'expectedDeliveryDate': expectedDeliveryDate.toIso8601String(),
      'weekOfPregnancy': weekOfPregnancy,
    };
  }
  

  factory PregnancyTrackerModel.fromJson(Map<String, dynamic> json) {
    return PregnancyTrackerModel(
      pregnancyId: json['pregnancyId'] ?? '',
      userId: json['userId'] ?? '',
      lastMenstrualDate: DateTime.parse(json['lastMenstrualDate'] ?? DateTime.now().toIso8601String()),
      babyName: json['babyName'] ?? '',
      expectedDeliveryDate: DateTime.parse(json['expectedDeliveryDate'] ?? DateTime.now().toIso8601String()),
      weekOfPregnancy: json['weekOfPregnancy'] ?? 0,
    );
  }
}
