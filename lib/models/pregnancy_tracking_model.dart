class PregnancyTracking {
  final int id;
  final int userId;
  final DateTime pregnancyStartDate;
  final DateTime expectedDeliveryDate;
  final String babyName;
  final String babyGender;
  final String notes;

  PregnancyTracking({
    required this.id,
    required this.userId,
    required this.pregnancyStartDate,
    required this.expectedDeliveryDate,
    required this.babyName,
    required this.babyGender,
    required this.notes,
  });

  int getPregnancyWeek() {
    return DateTime.now().difference(pregnancyStartDate).inDays ~/ 7;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'pregnancyStartDate': pregnancyStartDate.toIso8601String(),
      'expectedDeliveryDate': expectedDeliveryDate.toIso8601String(),
      'babyName': babyName,
      'babyGender': babyGender,
      'notes': notes,
    };
  }

  factory PregnancyTracking.fromMap(Map<String, dynamic> map) {
    return PregnancyTracking(
      id: map['id'],
      userId: map['userId'],
      pregnancyStartDate: DateTime.parse(map['pregnancyStartDate']),
      expectedDeliveryDate: DateTime.parse(map['expectedDeliveryDate']),
      babyName: map['babyName'],
      babyGender: map['babyGender'],
      notes: map['notes'],
    );
  }
}
