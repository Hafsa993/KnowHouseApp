class Task {
  String title;
  DateTime deadline;
  String category;
  String difficulty;
  String description;
  int rewardPoints;
  bool isAccepted;
  bool isDeclined;
  bool isCompleted;
  String acceptedBy; // Username of the user who accepted the task
  String assignedTo;

  Task({
    required this.title,
    required this.deadline,
    required this.category,
    required this.difficulty,
    this.description = '',
    this.rewardPoints = 0,
    this.isAccepted = false,
    this.isDeclined = false,
    this.isCompleted = false,
    this.acceptedBy = '',
    this.assignedTo = '',
  });
}
