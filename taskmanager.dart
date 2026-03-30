//const - these are fixed labels, known at compile time , never change
import 'task.dart';

const String statusPending = 'pending';
const String statusDone = 'done';
const int maxTasks=100;

class TaskManager{
  //final - created once , never reassigned (but the list contents CAN change)
  final List<Task> tasks = [];

  //A counter that genuinely needs to increment -- var is correct here
  var _nextId = 1;

  void addTask(String tittle,{String? dueDate, List<String> tags =const []}){
    //final - this task object is created once and added , never reassigned
    final task = Task(id: _nextId, title:tittle,status: statusPending, dueDate: dueDate, tags: tags);
    tasks.add(task);
    _nextId++;
  }

  void markDone(int id){
    //firstWhere returns the task or throws - we''ll handle nul safely next step
    final task = tasks.firstWhere((t) => t.id == id);
    task.status = statusDone; //allowed because status is not final
  }
}
