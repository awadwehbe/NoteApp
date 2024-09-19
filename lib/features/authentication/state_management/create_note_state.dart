part of 'create_note_cubit.dart';

abstract class CreateNoteState extends Equatable {
  const CreateNoteState();

  @override
  List<Object> get props => [];
}

class CreateNoteInitial extends CreateNoteState {}

class CreateNoteLoading extends CreateNoteState {}

class CreateNoteSuccess extends CreateNoteState {
  final CreateNoteResponseModel note;

  const CreateNoteSuccess(this.note);

  @override
  List<Object> get props => [note];
}

class CreateNoteError extends CreateNoteState {
  final String error;

  const CreateNoteError(this.error);

  @override
  List<Object> get props => [error];
}

