import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    
    if (_isRegister) {
      viewModel.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );
    } else {
      viewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegister ? 'Register' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isRegister)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : () => _submitForm(context),
                child: Text(_isRegister ? 'Register' : 'Login'),
              ),
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (viewModel.error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    viewModel.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegister = !_isRegister;
                  });
                },
                child: Text(_isRegister
                    ? 'Already have an account? Login'
                    : 'Need an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}