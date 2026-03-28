import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_schedule/src/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';
import 'package:my_schedule/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:my_schedule/src/features/auth/presentation/pages/login_page.dart';

void main() {
  Future<void> pumpLogin(WidgetTester tester) async {
    final repository = InMemoryAuthRepository();
    final controller = AuthController(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
    );

    await tester.pumpWidget(
      MaterialApp(home: LoginPage(controller: controller)),
    );
  }

  testWidgets('shows login form by default', (tester) async {
    await pumpLogin(tester);

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Sign in'),
      ),
      findsOneWidget,
    );
    expect(find.text('Sign up'), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('toggle to register shows role dropdown', (tester) async {
    await pumpLogin(tester);

    await tester.tap(
      find.widgetWithText(TextButton, 'No account yet? Sign up'),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Sign up'),
      ),
      findsOneWidget,
    );
    expect(find.text('Role'), findsOneWidget);
  });

  testWidgets('login as admin navigates to admin home', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextField).at(0), 'admin@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'admin');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Admin'), findsOneWidget);
  });

  testWidgets('login as user navigates to user home', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextField).at(0), 'user@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'user');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, User'), findsOneWidget);
  });

  testWidgets('register creates new user and navigates to user home', (
    tester,
  ) async {
    await pumpLogin(tester);

    await tester.tap(
      find.widgetWithText(TextButton, 'No account yet? Sign up'),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'new@demo.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');

    await tester.tap(find.byType(DropdownButtonFormField<UserRole>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('User').last);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, User'), findsOneWidget);
  });

  testWidgets('invalid login shows error message', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextField).at(0), 'admin@demo.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid password'), findsOneWidget);
  });
}
