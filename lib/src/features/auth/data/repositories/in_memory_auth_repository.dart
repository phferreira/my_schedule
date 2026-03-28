import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/exceptions/auth_failure.dart';
import 'package:my_schedule/src/features/auth/domain/repositories/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({Map<String, AuthUserRecord>? seed})
    : _users = seed ?? _defaultSeed();

  final Map<String, AuthUserRecord> _users;

  @override
  Future<User> login({required String email, required String password}) async {
    final record = _users[email.toLowerCase()];
    if (record == null) {
      throw const AuthFailure('User not found');
    }
    if (record.password != password) {
      throw const AuthFailure('Invalid password');
    }
    return User(email: record.email, role: record.role);
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final key = email.toLowerCase();
    if (_users.containsKey(key)) {
      throw const AuthFailure('User already exists');
    }
    final record = AuthUserRecord(email: email, password: password, role: role);
    _users[key] = record;
    return User(email: record.email, role: record.role);
  }

  static Map<String, AuthUserRecord> _defaultSeed() {
    return {
      'admin@demo.com': const AuthUserRecord(
        email: 'admin@demo.com',
        password: 'admin',
        role: UserRole.admin,
      ),
      'user@demo.com': const AuthUserRecord(
        email: 'user@demo.com',
        password: 'user',
        role: UserRole.user,
      ),
    };
  }
}

class AuthUserRecord {
  const AuthUserRecord({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;
}
