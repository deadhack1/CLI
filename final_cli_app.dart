//-------------------------------
//Flutter Senior Roadmap - Hour 1 Mini Project
//A CLI task manager covering: null safety, var/final/const,collections,null-aware operators,closures, higher-order functions, and arrow functions.

//const- compile time constants, shared across the whole app
const String statusPending = 'pending';
const String statusDone = 'done';
const String noDate = 'No due date';
const String noTags = 'No tags';

// Data model--------------------
class Task {
  final int id;
  final String title;
  String status;
  final String? dueDate; //nullable-due date is optional;
  final List<String> tags;

  Task({
    required this.id,
    required this.title,
    this.status = statusPending,
    this.dueDate,
    this.tags = const [],
  });

  //Arrow -single expression returning the formatted string
  //.? safely access dueDate, ?? catches the null
  String get formattedDue => dueDate?.replaceAll('-', '/') ?? noDate;

  //Arrow - single expression, ternary fits cleanly in one line
  String get tagLine => tags.isNotEmpty ? tags.join(', ') : noTags;

  //Arrow - one string interpolation = one expression
  @override
  String toString() =>
      '[${status.toUpperCase()}] $id. $title | Due: $formattedDue | Tags: $tagLine';
}

//Task Manager--------------------
class TaskManager {
  //final - the list reference never changes , but contents do
  final List<Task> _tasks = [];
  var _nextId = 1;

  //--Mutations--------------------
  void addTask(String title, {String? dueDate, List<String> tags = const []}) {
    //final - this task is created once and handed to the list
    final task = Task(id: _nextId, title: title, dueDate: dueDate, tags: tags);
    _tasks.add(task);
    _nextId++;
  }

  //Block body - two statements (find + mutate), arrow wont work here
  void markDone(int id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.status = statusDone;
  }

  //- Queries using higher order functions--------------------

  //Arrow + .where() - single expression fliter
  List<Task> getByStatus(String status) =>
      _tasks.where((t) => t.status == status).toList();

  //Arrow - delegates to getByStatus, pure one liners
  List<Task> getPending() => getByStatus(statusPending);
  List<Task> getDone() => getByStatus(statusDone);

  //Closure that closes over 'tag' from outer call
  //Arrow -single .where() chain
  List<Task> getByTag(String tag) =>
      _tasks.where((t) => t.tags.contains(tag)).toList();

  //.map() transforms Task -> String , arror keeps it one expression
  List<String> getTitles() => _tasks.map((t) => t.title).toList();

  //chained .where() + .map() -filter then transform
  List<String> getDoneTitles() => _tasks
      .where((t) => t.status == statusDone)
      .map((t) => '✓ ${t.title}')
      .toList();

  //.fold()-collapses the list into single int , arrow fits
  int countDone() =>
      _tasks.fold(0, (count, t) => t.status == statusDone ? count + 1 : count);

  //fold()building a Map - block body beacause the accumulator needs two operation (addAll is a statement, not an expression)
  Set<String> getAllUniqueTags() =>
      _tasks.fold<Set<String>>({}, (tags, t) => tags..addAll(t.tags));

  //Homework Solution: get the most common tag
  String? getTopTag() {
    final tagCounts = _tasks.fold<Map<String, int>>({}, (counts, task) {
      for (final tag in task.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
      return counts;
    });
    if (tagCounts.isEmpty) return null;
    return tagCounts.entries
        .fold(
          tagCounts.entries.first,
          (best, entry) => entry.value > best.value ? entry : best,
        )
        .key;
  }

  //fold() building a summary Map - block body for same reason as above
  Map<String, int> getSummary() => _tasks.fold<Map<String, int>>(
    {statusPending: 0, statusDone: 0},
    (map, t) {
      map[t.status] = (map[t.status] ?? 0) + 1;
      return map;
    },
  );

  //- Display--------------------

  //Block body - has an If- guard before the loop two statemens minimum
  void printList(List<Task> list,{String header=''}){
    if(header.isNotEmpty) print('\n=== $header ===');
    if(list.isEmpty){print(' (none)'); return;}
    list.forEach(print); //print is itself a function - pass it directly
  }

  void printSummary(){
    final summary = getSummary();
    final topTag=getTopTag();

    print('\n=== Summary ===');
    summary.entries.forEach((e)=>print(' ${e.key}: ${e.value} task(s)'));
    print('   Completed: ${countDone()} of ${_tasks.length} tasks');
    print('   All tags : ${getAllUniqueTags().join(', ')}');
    print('   Top Tag: ${topTag??'No Tags Found'}');
  }
}
//Entry point--------------------
void main(){
  final manager = TaskManager();

  //Add Tasks
  manager.addTask('Learn Dart null safety');
  manager.addTask('Build CLI app',
      dueDate: '2026-04-01', tags: ['flutter', 'dart']);
  manager.addTask('Read clean architecture book',
      tags: ['reading']);
  manager.addTask('Watch Riverpod tutorial',
      dueDate: '2026-04-05', tags: ['flutter', 'state']);
  manager.addTask('Write unit tests',
      tags: ['dart', 'testing']);
  manager.addTask('Set up CI pipeline',
      dueDate: '2026-04-10', tags: ['flutter', 'devops']);

  // Show everything
  manager.printList(manager._tasks.toList(), header: 'All Tasks');

  // Complete some tasks
  manager.markDone(1);
  manager.markDone(3);
  manager.markDone(5);

  manager.printList(manager.getDone(),    header: 'Completed');
  manager.printList(manager.getPending(), header: 'Pending');
  manager.printList(manager.getByTag('flutter'), header: 'Flutter Tasks');

  print('\n=== Done Titles ===');
  manager.getDoneTitles().forEach(print);

  print('\n=== All Titles ===');
  manager.getTitles().forEach(print);

  manager.printSummary();
}