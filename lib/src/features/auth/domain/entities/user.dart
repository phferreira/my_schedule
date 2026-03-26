import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';

class User {
  const User({required this.email, required this.role});

  final String email;
  final UserRole role;
}
