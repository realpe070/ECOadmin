class ActivityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int minTime;
  final int maxTime;
  final String? videoPath;
  final DateTime date;

  ActivityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.minTime,
    required this.maxTime,
    this.videoPath,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'minTime': minTime,
      'maxTime': maxTime,
      'videoPath': videoPath,
      'date': date.toIso8601String(),
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      minTime: map['minTime'],
      maxTime: map['maxTime'],
      videoPath: map['videoPath'],
      date: DateTime.parse(map['date']),
    );
  }
}
