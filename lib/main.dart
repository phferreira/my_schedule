import 'package:flutter/material.dart';
import 'package:my_schedule/src/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';
import 'package:my_schedule/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = InMemoryAuthRepository();
    final loginUseCase = LoginUseCase(repository);
    final registerUseCase = RegisterUseCase(repository);
    final controller = AuthController(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
    );

    return MaterialApp(
      title: 'My Schedule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: LoginPage(controller: controller),
    );
  }
}
