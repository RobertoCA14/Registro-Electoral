class Event {
  final int id;
  final String title;
  final String date;
  final String description;
  final String? imagePath;
  final String? audioPath;

  Event({
    this.id = 0,
    required this.title,
    required this.date,
    required this.description,
    this.imagePath,
    this.audioPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'imagePath': imagePath,
      'audioPath': audioPath,
    };
  }

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      description: json['description'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
    );
  }
}
