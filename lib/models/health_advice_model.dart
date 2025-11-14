class HealthAdviceModel {
  final String adviceId;
  final String title;
  final String content;
  final String bodyPart;
  final String category;

  HealthAdviceModel({
    required this.adviceId,
    required this.title,
    required this.content,
    required this.bodyPart,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'adviceId': adviceId,
      'title': title,
      'content': content,
      'bodyPart': bodyPart,
      'category': category,
    };
  }

  factory HealthAdviceModel.fromJson(Map<String, dynamic> json) {
    return HealthAdviceModel(
      adviceId: json['adviceId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
