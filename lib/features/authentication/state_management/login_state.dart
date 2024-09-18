part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
  final LoginResponseModel  LoginresponseModel;// Holds the response on success
  LoginSuccess({required this.LoginresponseModel});

}
class LoginError extends LoginState {
  final String errorMessage; // Holds the error message

  LoginError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage]; // For equality checks between states
}
