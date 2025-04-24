import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import '../views/task_detail_screen.dart';
import '../views/share_task_screen.dart';

class EnhancedTaskListItem extends StatelessWidget {
  final Task task;
  final bool isOwner;

  const EnhancedTaskListItem({
    super.key,
    required this.task,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    
    return Slidable(
      key: Key(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (isOwner) ...[
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareTaskScreen(taskId: task.id),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.deleteTask(task.id);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
          if (!isOwner)
            SlidableAction(
              onPressed: (context) {
                final updatedTask = Task(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  isCompleted: !task.isCompleted,
                  ownerId: task.ownerId,
                  sharedWith: task.sharedWith,
                  createdAt: task.createdAt,
                  updatedAt: DateTime.now(),
                );
                viewModel.updateTask(updatedTask);
              },
              backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
              icon: task.isCompleted ? Icons.refresh : Icons.check,
              label: task.isCompleted ? 'Reopen' : 'Complete',
            ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: task.isCompleted ? Colors.green : Colors.grey,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description.length > 50
                    ? '${task.description.substring(0, 50)}...'
                    : task.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isOwner
                    ? '${task.sharedWith.length} people sharing'
                    : 'Shared with you',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Text(
            '${task.updatedAt.day}/${task.updatedAt.month}/${task.updatedAt.year}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task, isOwner: isOwner),
              ),
            );
          },
        ),
      ),
    );
  }
}