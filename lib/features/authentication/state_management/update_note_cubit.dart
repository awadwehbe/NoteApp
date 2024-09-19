import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/updateNotes_request.dart';
import '../models/updateNotes_response.dart';
import '../repository/notes_repository.dart';


part 'update_note_state.dart';

class UpdateNoteCubit extends Cubit<UpdateNoteState> {
  final NotesRepository notesRepository;

  UpdateNoteCubit(this.notesRepository) : super(UpdateNoteInitial());

  Future<void> updateNote(
      UpdateNoteRequestModel request, String accessToken) async {
    try {
      emit(UpdateNoteLoading());
      final response = await notesRepository.updateNote(request, accessToken);
      emit(UpdateNoteSuccess(response.data!));
    } catch (error) {
      emit(UpdateNoteError(error.toString()));
    }
  }
}

