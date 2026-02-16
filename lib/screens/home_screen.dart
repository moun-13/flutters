import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import 'edit_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  get index => null;

  @override
  void  initState(){
    super.initState();
    loadTasks();
  }
  //charger les taches depuis SQlite
  void loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = data ;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant, // Subtle background
      appBar: AppBar(
        title: const Text("ToDo App"),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.checklist_rtl_rounded, size: 80, color: Colors.grey[400]),
                   const SizedBox(height: 16),
                   Text(
                    "Aucune tâche pour le moment",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks[index],
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text(
                          "Vous voulez supprimer cette tâche ?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Non"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await DatabaseHelper.instance
                                  .deleteTask(tasks[index].id!);
                              Navigator.pop(context);
                              loadTasks();
                            },
                            child: const Text("Oui", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  onToggle: () async {
                    Task task = tasks[index];
                    task.isCompleted = !task.isCompleted;
                    await DatabaseHelper.instance.updateTask(task);
                    loadTasks();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // FIX: Navigating to AddTaskScreen instead of EditTaskScreen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
          loadTasks();
        },
        label: const Text("Ajouter"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
