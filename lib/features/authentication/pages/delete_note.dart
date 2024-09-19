import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/getNotes_response.dart';
import '../state_management/delete_note_cubit.dart';
import '../state_management/get_note_cubit.dart';

class DeleteNote extends StatelessWidget {
  final Note note;
  final String accessToken; // Add accessToken or other necessary parameters

  DeleteNote({super.key, required this.note, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteNoteCubit, DeleteNoteState>(
      listener: (context, state) {
        if (state is DeleteNoteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Note deleted successfully')),
          );
          // Refresh notes list after deletion
          context.read<GetNoteCubit>().getNotes(accessToken);
          Navigator.pop(context); // Optionally pop the screen after deletion
        } else if (state is DeleteNoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete note: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Delete Note'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you sure you want to delete this note?'),
                SizedBox(height: 20),
                Text(note.title ?? 'Untitled Note'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Perform the delete action using DeleteNoteCubit
                    context.read<DeleteNoteCubit>().deleteNote(note.id!, accessToken);
                  },
                  child: Text('Delete Note'),
                ),
                SizedBox(height: 20),
                if (state is DeleteNoteLoading)
                  CircularProgressIndicator(), // Show loading indicator while deleting
              ],
            ),
          ),
        );
      },
    );
  }
}

