class AuthState {
  final String? token;
  final String? userType;
  final Map<String, dynamic>? userData;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.token,
    this.userType,
    this.userData,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isLoggedIn => token != null;

  AuthState copyWith({
    String? token,
    String? userType,
    Map<String, dynamic>? userData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      token: token ?? this.token,
      userType: userType ?? this.userType,
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
