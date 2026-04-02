import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/exceptions/auth_failure.dart';
import 'package:my_schedule/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({supabase.SupabaseClient? client})
    : _client = client ?? supabase.Supabase.instance.client;

  final supabase.SupabaseClient _client;

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user ?? response.session?.user;
      if (authUser == null) {
        throw const AuthFailure('User not found');
      }
      final role = await _fetchRole(authUser.id);
      return User(email: authUser.email ?? email, role: role);
    } on supabase.AuthException catch (error) {
      throw AuthFailure(_mapAuthError(error));
    } on supabase.PostgrestException catch (error) {
      throw AuthFailure(_mapDatabaseError(error));
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final authUser = response.user ?? response.session?.user;
      if (authUser == null) {
        throw const AuthFailure(
          'Account created. Check your email to confirm sign up.',
        );
      }
      await _client.from('profiles').insert({
        'user_id': authUser.id,
        'role': _roleToString(role),
      });
      return User(email: authUser.email ?? email, role: role);
    } on supabase.AuthException catch (error) {
      throw AuthFailure(_mapAuthError(error));
    } on supabase.PostgrestException catch (error) {
      throw AuthFailure(_mapDatabaseError(error));
    }
  }

  Future<UserRole> _fetchRole(String userId) async {
    final data = await _client
        .from('profiles')
        .select('role')
        .eq('user_id', userId)
        .maybeSingle();
    if (data == null) {
      throw const AuthFailure(
        'Profile not found. Contact support to configure your access.',
      );
    }
    final roleValue = data['role'];
    if (roleValue is! String) {
      throw const AuthFailure('Profile role is invalid.');
    }
    return _roleFromString(roleValue);
  }

  UserRole _roleFromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
    }
    throw const AuthFailure('Profile role is invalid.');
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.user:
        return 'user';
    }
  }

  String _mapAuthError(supabase.AuthException error) {
    final code = error.code ?? '';
    switch (code) {
      case 'invalid_login_credentials':
        return 'Invalid email or password.';
      case 'email_not_confirmed':
        return 'Email not confirmed. Check your inbox to confirm.';
      case 'user_already_exists':
        return 'User already exists.';
      case 'signup_disabled':
        return 'Sign up is disabled for this project.';
      default:
        return error.message;
    }
  }

  String _mapDatabaseError(supabase.PostgrestException error) {
    if (error.code == '42501') {
      return 'Access denied. Check your profile permissions.';
    }
    return error.message;
  }
}
