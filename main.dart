import 'task.dart';

void main(){
  final t1=Task(id: 1, title: 'Learn Dart Null Saftey');
  final t2=Task(id: 2, title: 'Build CLI app',dueDate: '2026-04-01');

  print(t1.title);
  print(t1.dueDate);
  print(t2.dueDate);

}