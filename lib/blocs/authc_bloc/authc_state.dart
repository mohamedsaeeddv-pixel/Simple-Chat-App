part of 'authc_bloc.dart';

@immutable
abstract class AuthcState {}

class AuthcInitial extends AuthcState {}

class LoginLoading extends AuthcState {}

class LoginShowPassword extends AuthcState {}

class LoginSuccess extends AuthcState {
  final String provider; // "google" أو "email"
  LoginSuccess({required this.provider});
}

class LoginFailure extends AuthcState {
  final String errorMessage;
  LoginFailure({required this.errorMessage});
}
