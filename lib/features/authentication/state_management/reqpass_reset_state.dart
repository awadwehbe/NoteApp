part of 'reqpass_reset_cubit.dart';

abstract class ReqpassResetState {}

class ReqpassResetInitial extends ReqpassResetState {}

class ReqpassResetLoading extends ReqpassResetState {}

class ReqpassResetSuccess extends ReqpassResetState {
  final String message;

  ReqpassResetSuccess({required this.message});
}

class ReqpassResetError extends ReqpassResetState {
  final String error;

  ReqpassResetError({required this.error});
}

