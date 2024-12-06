// file: lib/data/repositories/task_repository.dart

import 'package:task_master/data/models/task_model.dart'; // Assuming Task is a model class
import 'package:sqflite/sqflite.dart'; // For database management

class TaskRepository {
  final Database database; // Database instance

  TaskRepository({required this.database});

  // Fetch all tasks from the database
  Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await database.query('tasks');

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Add a new task to the database
  Future<int> addTask(Task task) async {
    return await database.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    return await database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    return await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
