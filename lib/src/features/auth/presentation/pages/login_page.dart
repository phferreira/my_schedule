import 'package:flutter/material.dart';
import 'package:my_schedule/src/core/design_system/design_system.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/admin_home_page.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/user_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final isRegister = widget.controller.isRegisterMode;
        final isLoading = widget.controller.isLoading;
        final errorMessage = widget.controller.errorMessage;

        return Scaffold(
          appBar: AppBar(title: Text(isRegister ? 'Sign up' : 'Sign in')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    if (isRegister) ...[
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<UserRole>(
                        key: ValueKey(widget.controller.selectedRole),
                        initialValue: widget.controller.selectedRole,
                        decoration: const InputDecoration(labelText: 'Role'),
                        items: UserRole.values
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.label),
                              ),
                            )
                            .toList(),
                        onChanged: isLoading
                            ? null
                            : (role) {
                                if (role != null) {
                                  widget.controller.setRole(role);
                                }
                              },
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _handleSubmit(context, isRegister),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isRegister ? 'Sign up' : 'Sign in'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : widget.controller.toggleMode,
                      child: Text(
                        isRegister
                            ? 'Already have an account? Sign in'
                            : 'No account yet? Sign up',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Demo accounts: admin@demo.com / admin, user@demo.com / user',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit(BuildContext context, bool isRegister) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter email and password.')),
      );
      return;
    }

    final User? user = isRegister
        ? await widget.controller.register(email: email, password: password)
        : await widget.controller.login(email: email, password: password);

    if (!context.mounted) {
      return;
    }

    if (user == null) {
      return;
    }

    if (user.role == UserRole.admin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const UserHomePage()),
      );
    }
  }
}
