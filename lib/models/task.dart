class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime? deadline; // New field

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.deadline,
  });

  // Convert Task to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'deadline': deadline?.toIso8601String(), // Store as string
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }
}


