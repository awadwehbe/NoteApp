part of 'get_note_cubit.dart';


abstract class GetNoteState extends Equatable {
  const GetNoteState();

  @override
  List<Object?> get props => [];
}

// Initial state before any action is taken
class GetNoteInitial extends GetNoteState {}

// State while the notes are being loaded
class GetNoteLoading extends GetNoteState {}

// State when the notes have been successfully loaded
class GetNoteLoaded extends GetNoteState {
  final List<Note> notes;

  const GetNoteLoaded({required this.notes});

  @override
  List<Object?> get props => [notes];
}

// State when there's an error while loading the notes
class GetNoteError extends GetNoteState {
  final String errorMessage;

  const GetNoteError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
