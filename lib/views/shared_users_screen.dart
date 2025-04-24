import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_mgmt/viewmodels/user_model.dart';
import '../viewmodels/user_view_model.dart';

class SharedUsersScreen extends StatefulWidget {
  final List<String> userIds;
  final String taskTitle;

  const SharedUsersScreen({
    Key? key, 
    required this.userIds,
    required this.taskTitle,
  }) : super(key: key);

  @override
  _SharedUsersScreenState createState() => _SharedUsersScreenState();
}

class _SharedUsersScreenState extends State<SharedUsersScreen> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _usersFuture = userViewModel.getUsersByIds(widget.userIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Users - ${widget.taskTitle}'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading users: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final users = snapshot.data ?? [];
          
          if (users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.name[0].toUpperCase()),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}