import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../hive.dart';
import '../models/getNotes_response.dart';
import '../models/updateNotes_request.dart';
import '../state_management/update_note_cubit.dart';

import 'login.dart';

class EditNote extends StatefulWidget {
  final Note note;  // Assuming 'note' is of type NoteData (contains id, title, category, text, etc.)

  EditNote({super.key, required this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill the text fields with existing note data
    _titleController.text = widget.note.title!;
    _categoryController.text = widget.note.category!;
    _textController.text = widget.note.text!;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // Method to get accessToken from SharedPreferences
  Future<void> _checkTokens() async {
    String? accessToken =await SharedPrefsManager.getAccessToken() ;
    String? refreshToken =await SharedPrefsManager.getRefreshToken() ;
  }

  void _redirectToLogin() async{
    String? accessToken =await SharedPrefsManager.getAccessToken() ;
    if (accessToken == null || accessToken.isEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    }
  }


  // Function to trigger note update
  void _submitEditNote() async {
    // Get the accessToken from SharedPreferences
    final accessToken = await SharedPrefsManager.getAccessToken();

    if (accessToken != null) {
      // Prepare the updated note request
      final updateNoteRequest = UpdateNoteRequestModel(
        id: widget.note.id!,  // Use the note ID
        title: _titleController.text,
        category: _categoryController.text,
        text: _textController.text,
        accessToken: accessToken,  // Pass the fetched accessToken
      );

      // Call Cubit to update the note
      context.read<UpdateNoteCubit>().updateNote(updateNoteRequest, accessToken);
    } else {
      // Show an error if accessToken is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access token not found. Please login again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: BlocConsumer<UpdateNoteCubit, UpdateNoteState>(
        listener: (context, state) {
          if (state is UpdateNoteSuccess) {
            // Navigate back or show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Note updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is UpdateNoteError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update note: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is UpdateNoteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _textController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Text'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitEditNote,
                  child: const Text('Edit Note'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
