import 'task.dart';
import 'taskmanager.dart';

void main(){
  // final t1=Task(id: 1, title: 'Learn Dart Null Saftey');
  // final t2=Task(id: 2, title: 'Build CLI app',dueDate: '2026-04-01');

  // print(t1.title);
  // print(t1.dueDate);
  // print(t2.dueDate);

  final manager = TaskManager();
  

;

manager.addTask('Learn Dart Null Saftey');
manager.addTask('Build CLI app', dueDate: '2026-04-01', tags: ['flutter', 'dart']);
manager.addTask('Read clean architecture book', tags: ['reading']);

//Print all tasks to verify
for (final task in manager.tasks){
  print('${task.id}.[${task.status}] ${task.title}');
}

manager.markDone(1);
print('\nAfter marking task 1 as done:\n');
for(final task in manager.tasks){
  print('${task.id}. [${task.status}] $task.title');
}



}