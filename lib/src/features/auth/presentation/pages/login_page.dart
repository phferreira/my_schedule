import 'package:flutter/material.dart';
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
          appBar: AppBar(title: Text(isRegister ? 'Cadastro' : 'Login')),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    if (isRegister) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<UserRole>(
                        key: ValueKey(widget.controller.selectedRole),
                        initialValue: widget.controller.selectedRole,
                        decoration: const InputDecoration(labelText: 'Perfil'),
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
                    const SizedBox(height: 20),
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                          : Text(isRegister ? 'Cadastrar' : 'Entrar'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : widget.controller.toggleMode,
                      child: Text(
                        isRegister
                            ? 'Já tem conta? Entrar'
                            : 'Não tem conta? Cadastre-se',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Contas demo: admin@demo.com / admin, user@demo.com / user',
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe email e senha.')));
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
