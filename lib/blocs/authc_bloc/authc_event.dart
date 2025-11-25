part of 'authc_bloc.dart';

@immutable
abstract class AuthcEvent {}

class ShowOrHiddenPasswordEvent extends AuthcEvent {}

class LoginEvent extends AuthcEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class LoginWithGoogleEvent extends AuthcEvent {}
