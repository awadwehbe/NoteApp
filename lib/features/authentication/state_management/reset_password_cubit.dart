import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/reset_password_request.dart';
import '../repository/reset_password_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository resetPasswordRepository;

  ResetPasswordCubit({required this.resetPasswordRepository})
      : super(ResetPasswordInitial());

  Future<void> resetPassword(ResetPasswordRequestModel req) async {
    emit(ResetPasswordLoading());

    try {
      final response= await resetPasswordRepository.ResetPassword(req);

      if (response.statusCode == 200) {
        emit(ResetPasswordSuccess(message: response.message!));
      } else {
        emit(ResetPasswordError(errorMessage: response.message!));
      }
    } catch (error) {
      emit(ResetPasswordError(errorMessage: 'An error occurred: $error'));
    }
  }
}

