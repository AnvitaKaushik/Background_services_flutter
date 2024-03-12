// login_state.dart
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

class LoginSuccess extends LoginState {}

class LocationPermissionDenied extends LoginState {
  final String error;

  const LocationPermissionDenied(this.error);

  @override
  List<Object> get props => [error];
}
