import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/reqpass_reset_request.dart';
import '../models/reqpass_reset_response.dart';
import '../repository/reqpass_reset_repository.dart';
part 'reqpass_reset_state.dart';


class ReqpassResetCubit extends Cubit<ReqpassResetState> {
  final ReqpassResetRepository reqpassResetRepository;

  ReqpassResetCubit({required this.reqpassResetRepository}) : super(ReqpassResetInitial());

  // Function to request password reset
  Future<void> requestPasswordReset(ReqpassResetRequesetModel reqpassResetRequest) async {
    try {
      // Emit loading state
      emit(ReqpassResetLoading());

      // Make the API call using the repository
      final response = await reqpassResetRepository.login(reqpassResetRequest);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Emit success state with the response message
        emit(ReqpassResetSuccess(message: response.message ?? 'Password reset request successful.'));
      } else {
        // Emit error state if the status code is not successful
        emit(ReqpassResetError(error: response.message ?? 'Unknown error occurred'));
      }
    } catch (error) {
      // Emit error state if an exception occurs
      emit(ReqpassResetError(error: error.toString()));
    }
  }
}
