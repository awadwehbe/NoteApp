import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../repository/login_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;//Inject the UserRepository to handle API calls
  LoginCubit(this.repository) : super(LoginInitial());
  Future<void> Login(LoginRequestModel LoginRequest)async {
    try {
      emit(LoginLoading());

      // Call the repository's sign-up method
      final response = await repository.login( LoginRequest);
      if (response.statusCode == 200) {
        if(response.data != null && response.data != null)
        emit(LoginSuccess(LoginresponseModel: response.data!));
      }
      else {
        emit(LoginError(errorMessage: response
            .message)); // Emit error if status code is not 200
      }
    }
    catch(e){
      emit(LoginError(errorMessage: e.toString())); // Catch any errors and emit error state
    }
  }
}