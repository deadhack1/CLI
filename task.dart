class Task{
  final int id;
  final String title;
  String status;
  final String? dueDate;
  final List<String> tags;
  Task({
    required this.id,
    required this.title,
    this.status='pending',
    this.dueDate,
    this.tags=const [],
  });
}