part of 'authc_cubit.dart';

@immutable
abstract class AuthcState {}

class AuthcInitial extends AuthcState {}
class LoginLoading extends AuthcState {}
class LoginSuccess extends AuthcState {}
class LoginShowPassword extends AuthcState {}
class LoginFailure extends AuthcState {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}

class RegisterLoading extends AuthcState {}
class RegisterSuccess extends AuthcState {}
class RegisterFailure extends AuthcState {
  String errorMessage;
  RegisterFailure({required this.errorMessage});
}
