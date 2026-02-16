import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/edit_tasks_screen.dart';

class TaskTile extends StatelessWidget {

  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        //  CHECKBOX
        leading: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            activeColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            value: task.isCompleted,
            onChanged: (value) {
              onToggle();
            },
          ),
        ),

        // CLIQUER POUR MODIFIER
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: task),
            ),
          );

          // Refresh HomeScreen by calling onToggle (which calls loadTasks in parent)
          // A bit of a hack reusing onToggle for refresh if we don't change state
          onToggle(); 
        },

        // TITRE
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),

        // DESCRIPTION
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              if (task.deadline != null) ...[
                const SizedBox(height: 8),
                _buildDeadlineText(task.deadline!),
              ],
            ],
          ),
        ),

        //SUPPRIMER
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }

  Widget _buildDeadlineText(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    final isOverdue = difference.isNegative;
    
    String text;
    Color color;
    IconData icon;

    if (task.isCompleted) {
       text = "Terminée le ${deadline.toString().split(' ')[0]}";
       color = Colors.grey;
       icon = Icons.event_available;
    } else if (isOverdue) {
      text = "En retard !";
      color = Colors.red;
      icon = Icons.warning_amber_rounded;
    } else {
      if (difference.inDays > 0) {
        text = "Reste : ${difference.inDays} j ${difference.inHours % 24} h";
      } else if (difference.inHours > 0) {
        text = "Reste : ${difference.inHours} h ${difference.inMinutes % 60} min";
      } else {
        text = "Reste : ${difference.inMinutes} min";
      }
      color = Colors.blueAccent;
      icon = Icons.timer;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
