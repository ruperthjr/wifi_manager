import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({AppUser? user, bool? isLoading, String? error}) => AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (email.isNotEmpty && password.length >= 6) {
      state = AuthState(
        user: AppUser(
          id: 'usr_001',
          fullName: _nameFromEmail(email),
          email: email,
        ),
      );
      return true;
    }
    state = AuthState(error: 'Invalid credentials. Please try again.');
    return false;
  }

  Future<bool> signup(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (fullName.trim().length >= 2 && email.contains('@') && password.length >= 6) {
      state = AuthState(
        user: AppUser(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          fullName: fullName.trim(),
          email: email.trim(),
        ),
      );
      return true;
    }
    state = AuthState(error: 'Please fill in all fields correctly.');
    return false;
  }

  void logout() => state = const AuthState();

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    return local[0].toUpperCase() + local.substring(1);
  }
}