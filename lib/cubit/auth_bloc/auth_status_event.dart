part of "auth_status_bloc.dart";

abstract class AuthStatusEvent extends Equatable {
  const AuthStatusEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogoutEvent extends AuthStatusEvent {}

class LoginInUsingGoogleEvent extends AuthStatusEvent {}

class ChangeSomeUiEvent extends AuthStatusEvent {}

class LoginInUsingEmailEvent extends AuthStatusEvent {
  final String email;
  final String password;

  LoginInUsingEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignUpInUsingEmailEvent extends AuthStatusEvent {
  final String email;
  final String password;

  SignUpInUsingEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class ForgetPasswordEvent extends AuthStatusEvent {
  final String email;

  ForgetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}
