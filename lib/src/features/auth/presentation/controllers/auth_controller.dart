import 'package:flutter/foundation.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user.dart';
import 'package:my_schedule/src/features/auth/domain/entities/user_role.dart';
import 'package:my_schedule/src/features/auth/domain/exceptions/auth_failure.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/login_use_case.dart';
import 'package:my_schedule/src/features/auth/domain/usecases/register_use_case.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase;

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  bool _isLoading = false;
  bool _isRegisterMode = false;
  String? _errorMessage;
  UserRole _selectedRole = UserRole.user;

  bool get isLoading => _isLoading;
  bool get isRegisterMode => _isRegisterMode;
  String? get errorMessage => _errorMessage;
  UserRole get selectedRole => _selectedRole;

  void toggleMode() {
    _isRegisterMode = !_isRegisterMode;
    _errorMessage = null;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<User?> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      final user = await _loginUseCase(email: email, password: password);
      _errorMessage = null;
      return user;
    } on AuthFailure catch (failure) {
      _errorMessage = failure.message;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final user = await _registerUseCase(
        email: email,
        password: password,
        role: _selectedRole,
      );
      _errorMessage = null;
      return user;
    } on AuthFailure catch (failure) {
      _errorMessage = failure.message;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
