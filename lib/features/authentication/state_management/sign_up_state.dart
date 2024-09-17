part of 'sign_up_cubit.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState{}

class SignUpSuccess extends SignUpState{
  final SignupResponseModel  SignUpresponseModel;// Holds the response on success
  SignUpSuccess({required this.SignUpresponseModel});

}
class SignUpError extends SignUpState {
  final String errorMessage; // Holds the error message

  SignUpError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage]; // For equality checks between states
}


