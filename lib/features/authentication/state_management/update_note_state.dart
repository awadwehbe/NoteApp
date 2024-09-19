part of 'update_note_cubit.dart';

abstract class UpdateNoteState extends Equatable {
  const UpdateNoteState();

  @override
  List<Object> get props => [];
}

class UpdateNoteInitial extends UpdateNoteState {}

class UpdateNoteLoading extends UpdateNoteState {}

class UpdateNoteSuccess extends UpdateNoteState {
  final UpdateNoteResponseModel note;

  const UpdateNoteSuccess(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteError extends UpdateNoteState {
  final String error;

  const UpdateNoteError(this.error);

  @override
  List<Object> get props => [error];
}
