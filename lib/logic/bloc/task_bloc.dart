import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/data/repository/task_repository.dart';
import 'package:task_master/data/models/task_model.dart';

// Event classes (for adding, updating, deleting tasks)
abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  DeleteTaskEvent(this.taskId);
}

// State classes (for managing the state of tasks)
abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> tasks;

  TaskLoadedState(this.tasks);
}

class TaskErrorState extends TaskState {
  final String message;

  TaskErrorState(this.message);
}

// TaskBloc class (where logic for handling events is defined)
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskInitialState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasksEvent) {
      yield TaskLoadingState();
      try {
        final tasks = await taskRepository.getTasks();
        yield TaskLoadedState(tasks);
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is AddTaskEvent) {
      try {
        await taskRepository.addTask(event.task);
        final tasks = await taskRepository.getTasks();
        yield TaskLoadedState(tasks);
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is UpdateTaskEvent) {
      try {
        await taskRepository.updateTask(event.task);
        final tasks = await taskRepository.getTasks();
        yield TaskLoadedState(tasks);
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is DeleteTaskEvent) {
      try {
        await taskRepository.deleteTask(event.taskId);
        final tasks = await taskRepository.getTasks();
        yield TaskLoadedState(tasks);
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }
  }
}
