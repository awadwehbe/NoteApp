part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class SignUpInitial extends OtpState {}

class SignUpLoading extends OtpState{}

class OtpSuccess extends OtpState{
  final String message;
  OtpSuccess({required this.message});

}
class OtpError extends OtpState {
  final String errorMessage; // Holds the error message

  OtpError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage]; // For equality checks between states
}
