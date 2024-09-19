import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/authentication/state_management/create_note_cubit.dart';

import '../../../core/network/api_client.dart';
import '../../../hive.dart';
import '../state_management/delete_note_cubit.dart';
import '../state_management/get_note_cubit.dart';
import 'create_note.dart';
import 'delete_note.dart';
import 'edit_note.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateNote()), // Navigates to CreateNote
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to user profile page
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: SharedPrefsManager.getAccessToken(), // Retrieve the access token from Hive
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loader while waiting for token
          } else if (snapshot.hasError) {
            return Center(child: Text('Error retrieving access token: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Access token not found'));
          } else {
            final accessToken = snapshot.data!;

            // Initialize HomeCubit and fetch notes
            return FutureBuilder<bool>(
              future: ApiClient.refreshAccessTokenIfNeeded(accessToken), // Check if token is valid, refresh if needed
              builder: (context, tokenSnapshot) {
                if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (tokenSnapshot.hasError || !tokenSnapshot.hasData || tokenSnapshot.data == false) {
                  return Center(child: Text('Failed to refresh token or token invalid'));
                } else {
                  // If token is valid, fetch notes
                  context.read<GetNoteCubit>().getNotes(accessToken);

                  return BlocBuilder<GetNoteCubit, GetNoteState>(
                    builder: (context, state) {
                      if (state is GetNoteLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is GetNoteLoaded) {
                        final notes = state.notes; // List of notes from the state

                        return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 10,
                                shadowColor: Colors.purple.withOpacity(0.3),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade50,
                                        Colors.purple.shade100
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title ?? 'Untitled Note',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.purple.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        note.category ?? 'Uncategorized',
                                        style: TextStyle(
                                          color: Colors.purple.shade600,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        note.text ?? 'No content',
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.purple.shade700,
                                          fontSize: 18,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Navigate to EditNotePage
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditNote(
                                                    note: note,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.edit, color: Colors.purple.shade700),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => DeleteNote( note: note,accessToken: accessToken,)), // Navigates to CreateNote
                                              );
                                            },
                                            icon: Icon(Icons.delete, color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is GetNoteError) {
                        return Center(child: Text(state.errorMessage)); // Display error message
                      } else {
                        return Center(child: Text('No notes found'));
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}



