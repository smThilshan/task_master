import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_master/core/navigation/app_router.dart';
import 'package:task_master/data/repository/task_repository.dart';
import 'package:task_master/logic/bloc/task_bloc.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database (example with sqflite)
  final Database mydatabase = await openDatabase('task_master.db');

  // Initialize the task repository (SQLite database)
  final taskRepository = TaskRepository(database: mydatabase);

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(taskRepository), // Providing the TaskBloc
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TaskMaster',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/', // Initial screen is HomeScreen
        onGenerateRoute: AppRouter.generateRoute, // Centralized routing
      ),
    );
  }
}
