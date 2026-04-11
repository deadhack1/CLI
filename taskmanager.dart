//const - these are fixed labels, known at compile time , never change
import 'task.dart';

const String statusPending = 'pending';
const String statusDone = 'done';
const int maxTasks = 100;

class TaskManager {
  //final - created once , never reassigned (but the list contents CAN change)
  final List<Task> tasks = [];

  //A counter that genuinely needs to increment -- var is correct here
  var _nextId = 1;

  void addTask(String tittle, {String? dueDate, List<String> tags = const []}) {
    //final - this task object is created once and added , never reassigned
    final task = Task(
      id: _nextId,
      title: tittle,
      status: statusPending,
      dueDate: dueDate,
      tags: tags,
    );
    tasks.add(task);
    _nextId++;
  }

  void markDone(int id) {
    //firstWhere returns the task or throws - we''ll handle nul safely next step
    final task = tasks.firstWhere((t) => t.id == id);
    task.status = statusDone; //allowed because status is not final
  }

  // New : Map -- builing a summary of tasks grouped by status
  Map<String, int> getSummary() {
    //Start with a Map where every status begins at 0
    final Map<String, int> summary = {statusPending: 0, statusDone: 0};

    for (final task in tasks) {
      //sumary[task.status] could be null if an unknown status existed
      //?? 0 ensures we never add to null
      summary[task.status] = (summary[task.status] ?? 0) + 1;
    }
    return summary;
  }

  //New Set- collect every unique tag across all tasks
  Set<String> getAllUniqueTags() {
    final Set<String> uniqueTags = {};

    for (final task in tasks) {
      //Set.addAll() ignores duplicates automatically
      uniqueTags.addAll(task.tags);
    }
    return uniqueTags;
  }

  //New : null-aware display - format a single task safely
  String formatTask(Task task) {
    //?. safely access dueDate, ?? provides a default if it's null.
    final due = task.dueDate?.replaceAll('-', '/') ?? 'No due date';

    //if no tags , show a fallback - json() on empty list gives empty string
    final tagLine = task.tags.isNotEmpty ? task.tags.join(',  ') : 'no tags';
    return '[${task.status.toUpperCase()}] ${task.id}. ${task.title} | Due:$due | Tags: $tagLine';
  }

  void printAll(){
    if(tasks.isEmpty){
      print('No tasks to display.');
  }
  for (final task in tasks){
    print(formatTask(task));
  
  }
  }

  void printSummary(){
    final summary = getSummary();
    final tags=getAllUniqueTags();

    print('\n---Summary---');
    //Map Iteration gives you MapEntry with .key and .value
    for(final entry in summary.entries){
      print('${entry.key}: ${entry.value} tasks(s)');

    }
    print('\nAll Unique tags: ${tags.isEmpty?'none':tags.join(', ')}');
  }
}
