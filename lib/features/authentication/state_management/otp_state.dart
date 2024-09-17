part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class SignUpInitial extends OtpState {}

class SignUpLoading extends OtpState{}

class OtpSuccess extends OtpState{
  final OtpResponseModel  otpresponseModel;// Holds the response on success
  OtpSuccess({required this.otpresponseModel});

}
class OtpError extends OtpState {
  final String errorMessage; // Holds the error message

  OtpError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage]; // For equality checks between states
}
