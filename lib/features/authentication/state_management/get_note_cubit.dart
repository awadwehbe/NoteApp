import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/getNotes_response.dart';
import '../repository/notes_repository.dart';

part 'get_note_state.dart';


class GetNoteCubit extends Cubit<GetNoteState> {
  final NotesRepository notesRepository;

  GetNoteCubit({required this.notesRepository}) : super(GetNoteInitial());

  // Method to get notes
  Future<void> getNotes(String accessToken) async {
    try {
      emit(GetNoteLoading()); // Emit loading state

      // Fetch notes from repository
      final response = await notesRepository.getNotes(accessToken);

      // Check the response status code
      if (response.statusCode == 200) {
        emit(GetNoteLoaded(notes: response.data?.notes ?? [])); // Emit loaded state with notes
      } else {
        emit(GetNoteError(errorMessage: response.message ?? 'Failed to load notes')); // Emit error state with the message
      }
    } catch (e) {
      emit(GetNoteError(errorMessage: 'An error occurred: $e')); // Emit error state in case of an exception
    }
  }
}

