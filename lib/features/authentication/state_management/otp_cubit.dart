import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/otp_request.dart';
import '../models/otp_response.dart';
import '../repository/otp_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;//Inject the UserRepository to handle API calls
  OtpCubit(this.repository) : super(SignUpInitial());

// Step 3: Define the method to trigger the signup process
  Future<void> Otpval(OtpRequestModel otpRequest)async {
    try {
      emit(SignUpLoading());

      // Call the repository's sign-up method
      final response = await repository.Otpval( otpRequest);
      if (response.statusCode == 200) {
        emit(OtpSuccess(message: response.message));
      }
      else {
        emit(OtpError(errorMessage: response
            .message)); // Emit error if status code is not 200
      }
    }
    catch(e){
      emit(OtpError(errorMessage: e.toString())); // Catch any errors and emit error state
    }
  }
}
