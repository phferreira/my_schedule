import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_schedule/src/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/exceptions/auth_failure.dart';
import 'package:my_schedule/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';
import 'package:my_schedule/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpLogin(WidgetTester tester, AuthRepository repository) async {
    final controller = AuthController(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: LoginPage(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> setSurfaceSize(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });
  }

  testWidgets('login page - login mode', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, InMemoryAuthRepository());

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_login.png'),
    );
  });

  testWidgets('login page - register mode', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, InMemoryAuthRepository());

    await tester.tap(find.text('Não tem conta? Cadastre-se'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_register.png'),
    );
  });

  testWidgets('login page - filled fields', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, InMemoryAuthRepository());

    await tester.enterText(find.byType(TextField).at(0), 'user@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'user');
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_filled.png'),
    );
  });

  testWidgets('login page - register mode with dropdown open', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, InMemoryAuthRepository());

    await tester.tap(find.text('Não tem conta? Cadastre-se'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<UserRole>));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_register_dropdown.png'),
    );
  });

  testWidgets('login page - error state', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, InMemoryAuthRepository());

    await tester.enterText(find.byType(TextField).at(0), 'admin@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_error.png'),
    );
  });

  testWidgets('login page - loading state', (tester) async {
    await setSurfaceSize(tester);
    await pumpLogin(tester, DelayedAuthRepository());

    await tester.enterText(find.byType(TextField).at(0), 'user@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'user');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_page_loading.png'),
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });
}

class DelayedAuthRepository implements AuthRepository {
  DelayedAuthRepository({this.delay = const Duration(milliseconds: 600)});

  final Duration delay;

  @override
  Future<User> login({required String email, required String password}) async {
    await Future<void>.delayed(delay);
    if (password != 'user') {
      throw const AuthFailure('Senha inválida');
    }
    return User(email: email, role: UserRole.user);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future<void>.delayed(delay);
    return User(email: email, role: role);
  }
}
