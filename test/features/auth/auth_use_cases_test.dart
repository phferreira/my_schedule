import 'package:flutter_test/flutter_test.dart';
import 'package:my_schedule/src/features/auth/data/repositories/in_memory_auth_repository.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/exceptions/auth_failure.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';

void main() {
  group('Auth use cases', () {
    test('register then login returns user with expected role', () async {
      final repository = InMemoryAuthRepository();
      final register = RegisterUseCase(repository);
      final login = LoginUseCase(repository);

      final registered = await register(
        email: 'new.user@example.com',
        password: '123456',
        role: UserRole.user,
      );

      expect(registered.role, UserRole.user);

      final loggedIn = await login(
        email: 'new.user@example.com',
        password: '123456',
      );

      expect(loggedIn.role, UserRole.user);
    });

    test('login with wrong password throws AuthFailure', () async {
      final repository = InMemoryAuthRepository();
      final login = LoginUseCase(repository);

      expect(
        () => login(email: 'admin@demo.com', password: 'wrong'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
