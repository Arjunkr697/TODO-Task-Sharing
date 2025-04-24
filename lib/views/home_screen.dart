import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import 'auth_screen.dart';
import 'task_list_view.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);
    
    if (viewModel.currentUserId == null) {
      return const AuthScreen();
    }
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Sharing App'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => viewModel.signOut(),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Tasks'),
              Tab(text: 'Shared With Me'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskListView(tasks: viewModel.tasks, isOwner: true),
            TaskListView(tasks: viewModel.sharedWithMe, isOwner: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}