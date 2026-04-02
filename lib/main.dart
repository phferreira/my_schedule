import 'package:flutter/material.dart';
import 'package:my_schedule/src/core/config/app_env.dart';
import 'package:my_schedule/src/core/design_system/design_system.dart';
import 'package:my_schedule/src/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';
import 'package:my_schedule/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnv.validate();
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = SupabaseAuthRepository();
    final loginUseCase = LoginUseCase(repository);
    final registerUseCase = RegisterUseCase(repository);
    final controller = AuthController(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
    );

    return MaterialApp(
      title: 'My Schedule',
      theme: AppTheme.light(),
      home: LoginPage(controller: controller),
    );
  }
}
