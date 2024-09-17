import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:note_app/features/authentication/models/signup_response.dart';
import 'package:note_app/features/authentication/repository/signUp_repository.dart';

import '../models/signup_request.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository repository;//Inject the UserRepository to handle API calls
  SignUpCubit(this.repository) : super(SignUpInitial());

// Step 3: Define the method to trigger the signup process
Future<void> SignUp(SignupRequestModel signupRequest)async {
  try {
    emit(SignUpLoading());

    // Call the repository's sign-up method
    final response = await repository.signUp(signupRequest);
    if (response.statusCode == 200) {
      emit(SignUpSuccess(SignUpresponseModel: response.data!));
    }
    else {
      emit(SignUpError(errorMessage: response
          .message)); // Emit error if status code is not 200
    }
  }
  catch(e){
    emit(SignUpError(errorMessage: e.toString())); // Catch any errors and emit error state
  }
}
}
