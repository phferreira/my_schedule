import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    required UserRole role,
  });
}
