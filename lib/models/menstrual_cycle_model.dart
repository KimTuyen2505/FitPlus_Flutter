class MenstrualCycleModel {
  final String cycleId;
  final String userId;
  final DateTime startDate;
  final int cycleLengthDays;
  final int periodLengthDays;
  final String flowIntensity;
  final int painLevel;
  final String symptoms;

  MenstrualCycleModel({
    required this.cycleId,
    required this.userId,
    required this.startDate,
    required this.cycleLengthDays,
    required this.periodLengthDays,
    required this.flowIntensity,
    required this.painLevel,
    required this.symptoms,
  });

  // Dự đoán kỳ kinh tiếp theo
  DateTime get nextPeriodDate => startDate.add(Duration(days: cycleLengthDays));

  Map<String, dynamic> toJson() {
    return {
      'cycleId': cycleId,
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'cycleLengthDays': cycleLengthDays,
      'periodLengthDays': periodLengthDays,
      'flowIntensity': flowIntensity,
      'painLevel': painLevel,
      'symptoms': symptoms,
    };
  }

  factory MenstrualCycleModel.fromJson(Map<String, dynamic> json) {
    return MenstrualCycleModel(
      cycleId: json['cycleId'] ?? '',
      userId: json['userId'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      cycleLengthDays: json['cycleLengthDays'] ?? 28,
      periodLengthDays: json['periodLengthDays'] ?? 5,
      flowIntensity: json['flowIntensity'] ?? 'normal',
      painLevel: json['painLevel'] ?? 0,
      symptoms: json['symptoms'] ?? '',
    );
  }
}
