import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final bool isOwner;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks found'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskListItem(task: task, isOwner: isOwner);
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final bool isOwner;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: task.isCompleted ? Colors.green : Colors.grey,
        ),
        title: Text(task.title),
        subtitle: Text(
          isOwner
              ? '${task.sharedWith.length} people sharing'
              : 'Shared with you',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
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
    );
  }
}