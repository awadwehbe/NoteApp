import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/createNotes_request.dart';
import '../models/createNotes_response.dart';
import '../repository/notes_repository.dart';


part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  final NotesRepository notesRepository;

  CreateNoteCubit(this.notesRepository) : super(CreateNoteInitial());

  Future<void> createNote(
      CreateNoteRequestModel request, String accessToken) async {
    try {
      emit(CreateNoteLoading());
      final response = await notesRepository.createNote(request, accessToken);
      emit(CreateNoteSuccess(response.data!));
    } catch (error) {
      emit(CreateNoteError(error.toString()));
    }
  }
}

