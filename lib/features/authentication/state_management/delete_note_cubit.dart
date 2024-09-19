import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/deleteNotes_response.dart';
import '../repository/notes_repository.dart';

part 'delete_note_state.dart';


class DeleteNoteCubit extends Cubit<DeleteNoteState> {
  final NotesRepository notesRepository;

  DeleteNoteCubit(this.notesRepository) : super(DeleteNoteInitial());

  Future<void> deleteNote(String id, String accessToken) async {
    try {
      emit(DeleteNoteLoading());
      final response = await notesRepository.deleteNotes(id, accessToken);
      if (response.statusCode == 200) {
        emit(DeleteNoteSuccess(response.data!.message!));
      } else {
        emit(DeleteNoteError(response.message));
      }
    } catch (error) {
      emit(DeleteNoteError(error.toString()));
    }
  }
}
