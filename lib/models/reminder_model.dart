class ReminderModel {
  final String reminderId;
  final String userId;
  final String title;
  final String description;
  final DateTime reminderDateTime;
  final bool isCompleted;

  ReminderModel({
    required this.reminderId,
    required this.userId,
    required this.title,
    required this.description,
    required this.reminderDateTime,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'reminderId': reminderId,
      'userId': userId,
      'title': title,
      'description': description,
      'reminderDateTime': reminderDateTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      reminderId: json['reminderId'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reminderDateTime: DateTime.parse(json['reminderDateTime'] ?? DateTime.now().toIso8601String()),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
