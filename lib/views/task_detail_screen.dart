import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mgmt/views/shared_users_screen.dart';
import '../models/task.dart';
import '../viewmodels/task_view_model.dart';
import 'share_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final bool isOwner;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.isOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareTaskScreen(taskId: task.id),
                  ),
                );
              },
            ),
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.deleteTask(task.id);
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go back to list
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            if (value != null) {
                              final updatedTask = Task(
                                id: task.id,
                                title: task.title,
                                description: task.description,
                                isCompleted: value,
                                ownerId: task.ownerId,
                                sharedWith: task.sharedWith,
                                createdAt: task.createdAt,
                                updatedAt: DateTime.now(),
                              );
                              viewModel.updateTask(updatedTask);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(task.description),
                    const SizedBox(height: 16),
                    Text(
                      'Created: ${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      'Last updated: ${task.updatedAt.day}/${task.updatedAt.month}/${task.updatedAt.year}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isOwner) ...[
              const Text(
                'Share Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share via App'),
                  onTap: () => viewModel.shareTaskViaApp(task),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Share with User'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShareTaskScreen(taskId: task.id),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (isOwner && task.sharedWith.isNotEmpty) ...[
              const Text(
                'Shared With',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.people),
                  title: Text('${task.sharedWith.length} people sharing'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SharedUsersScreen(
                          userIds: task.sharedWith,
                          taskTitle: task.title,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (!isOwner) ...[
              const Text(
                'Owner Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // In a real app, you would fetch user details here
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Task owned by: ${task.ownerId}'),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                _showEditTaskDialog(context, viewModel);
              },
              child: const Icon(Icons.edit),
            )
          : null,
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskViewModel viewModel) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedTask = Task(
                id: task.id,
                title: titleController.text,
                description: descriptionController.text,
                isCompleted: task.isCompleted,
                ownerId: task.ownerId,
                sharedWith: task.sharedWith,
                createdAt: task.createdAt,
                updatedAt: DateTime.now(),
              );
              viewModel.updateTask(updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
