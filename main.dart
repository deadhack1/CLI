import 'task.dart';
import 'taskmanager.dart';

void main() {
  // final t1=Task(id: 1, title: 'Learn Dart Null Saftey');
  // final t2=Task(id: 2, title: 'Build CLI app',dueDate: '2026-04-01');

  // print(t1.title);
  // print(t1.dueDate);
  // print(t2.dueDate);

  final manager =
      TaskManager(); //final beacuse we create the manager once and never reassign it, but we can still add tasks to its list

  manager.addTask('Learn Dart Null Saftey');
  manager.addTask(
    'Build CLI app',
    dueDate: '2026-04-01',
    tags: ['flutter', 'dart'],
  );
  manager.addTask('Read clean architecture book', tags: ['reading']);
  manager.addTask(
    'Watch Riverpod tutorial',
    dueDate: '2026-04-20',
    tags: ['flutter', 'state'],
  );
  manager.addTask('Wrire unit tests',tags:['dart','testing']);

  manager.markDone(1);
  manager.markDone(3);

  print('=== All Titles ===');
  manager.getTaskTitles().forEach(print);

  print('/n== Completed ===');
  manager.getDoneTitles().forEach(print);

  print('\n== Flutter Tasks ===');
  manager.getTasksByTag('flutter').map(manager.formatTask).forEach(print);

  print('\n== Pending Tasks ===');
  manager.getPending().map(manager.formatTask).forEach(print);

  manager.printSummary();



  // print('===All Tasks===\n');
  // manager.printAll();
  // manager.printSummary();

  // //Print all tasks to verify
  // for (final task in manager.tasks) {
  //   print('${task.id}.[${task.status}] ${task.title}');
  // }

  // manager.markDone(1);
  // print('\nAfter marking task 1 as done:\n');
  // for (final task in manager.tasks) {
  //   print('${task.id}.[${task.status}] ${task.title}');
  // }
}
