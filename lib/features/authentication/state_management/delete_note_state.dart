part of 'delete_note_cubit.dart';

abstract class DeleteNoteState {}

class DeleteNoteInitial extends DeleteNoteState {}

class DeleteNoteLoading extends DeleteNoteState {}

class DeleteNoteSuccess extends DeleteNoteState {
  final String response;

  DeleteNoteSuccess(this.response);
}

class DeleteNoteError extends DeleteNoteState {
  final String error;

  DeleteNoteError(this.error);
}
