// splash_event.dart

abstract class SplashEvent {}

class LoadApp extends SplashEvent {}

class PostLocationUpdate extends SplashEvent {}

// splash_state.dart
abstract class SplashState {}

class InitialState extends SplashState {}

class LoadingState extends SplashState {}

class LoadedState extends SplashState {}

class TokenExpiredState extends SplashState {
  final String message;

  TokenExpiredState(this.message);
}

class ErrorState extends SplashState {
  final String message;

  ErrorState(this.message);
}
