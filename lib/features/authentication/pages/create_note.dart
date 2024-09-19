import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../hive.dart';
import '../models/createNotes_request.dart';
import '../state_management/create_note_cubit.dart';
import 'login.dart';


class CreateNote extends StatefulWidget {
  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String? _title;
  String? _text;

  @override
  void initState() {
    super.initState();
  }

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

  Future<void> _createNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? accessToken =await SharedPrefsManager.getAccessToken() ;

      if (accessToken != null) {
        // Prepare the request model with user input
        final request = CreateNoteRequestModel(
          category: _category!,
          title: _title!,
          text: _text!,
        );

        // Use Cubit to emit loading state and call repository
        context.read<CreateNoteCubit>().createNote(request, accessToken);
      } else {
        _redirectToLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        backgroundColor: Colors.purple,
      ),
      body: BlocConsumer<CreateNoteCubit, CreateNoteState>(
        listener: (context, state) {
          if (state is CreateNoteLoading) {
            // Show loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Creating note...')),
            );
          } else if (state is CreateNoteSuccess) {
            // On success, navigate or show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Note added successfully')),
            );
            Navigator.of(context).pop(); // Navigate back after successful note creation
          } else if (state is CreateNoteError) {
            // Handle errors and show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add note: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Colors.purple),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        hintText: 'Enter category',
                        hintStyle: TextStyle(color: Colors.purple),
                      ),
                      style: TextStyle(color: Colors.purple),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a category'
                          : null,
                      onSaved: (value) => _category = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.purple),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        hintText: 'Enter title',
                        hintStyle: TextStyle(color: Colors.purple),
                      ),
                      style: TextStyle(color: Colors.purple),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a title'
                          : null,
                      onSaved: (value) => _title = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Note Text',
                        labelStyle: TextStyle(color: Colors.purple),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        hintText: 'Enter your note',
                        hintStyle: TextStyle(color: Colors.purple),
                      ),
                      style: TextStyle(color: Colors.purple),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter note text'
                          : null,
                      onSaved: (value) => _text = value,
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _createNote(); // Use the Cubit method to send the request
                        },
                        child: Text('Add Note'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    // Optional UI to indicate loading state (if you don't want to rely on SnackBar alone)
                    if (state is CreateNoteLoading)
                      Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
