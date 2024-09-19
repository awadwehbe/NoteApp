
import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/createNotes_request.dart';
import '../models/createNotes_response.dart';
import '../models/deleteNotes_response.dart';
import '../models/getNotes_response.dart';
import '../models/updateNotes_request.dart';
import '../models/updateNotes_response.dart';

class NotesRepository {
  /// Get Notes method for signing in a user
  Future<ResponseModel<NotesResponseModel>> getNotes(String accessToken) async {
    try {
      // Print the access token and the request URL for debugging
      print('Access Token: $accessToken');
      print('Request URL: /notes/get-notes');

      // Sending API request
      final response = await ApiClient.requestWithAccessToken(
        method: 'GET',
        data: {},
        withToken: true,
        url: '/notes/get-notes',
        accessToken: accessToken,
      );

      // Print the raw API response (as a Map)
      print('Raw API Response: ${response.toJson()}');

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<NotesResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          print('Data to be parsed into NotesResponseModel: $data');
          return NotesResponseModel.fromJson(data); // Ensure correct parsing
        },
      );


      // Print out the parsed ResponseModel details
      print('Parsed ResponseModel: $responseModel');
      print('Status Code: ${responseModel.statusCode}');
      print('Message: ${responseModel.message}');

      // Print details of the notes list if available
      if (responseModel.data?.notes != null) {
        print('Notes List:');
        for (var note in responseModel.data!.notes!) {
          print('Note ID: ${note.id}');
          print('Note Category: ${note.category}');
          print('Note Title: ${note.title}');
          print('Note Text: ${note.text}');
          print('Note User: ${note.user}');
          print('---');
        }
      } else {
        print('No notes available in the response.');
      }

      return responseModel;
    } catch (error) {
      // Print the error in case of failure
      print('Error occurring: $error');
      throw error; // Re-throw the error to handle it in the caller
    }
  }


  ///POST
  Future<ResponseModel<CreateNoteResponseModel>> createNote(
      CreateNoteRequestModel req,String accessToken) async {
    try {
      // Print the login request details
      print('ReqpassReset Request: ${req.toJson()}');

      // Sending API request
      final response = await ApiClient.requestWithAccessToken(
        method: 'POST',
        data: req.toJson() ,
        withToken: true,
        url: '/notes/create-note',
        accessToken: accessToken,
      );

      // Print the raw API response (as a Map)
      print('Raw API Response: ${response.toJson()}');

      // Check the 'data' field in the response
      print('Raw API Data: ${response.toJson()['data']}');

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<CreateNoteResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          print('Data to be parsed into ResetPassResponseModel: $data');
          return CreateNoteResponseModel.fromJson(data); // Ensure correct parsing
        },
      );


      // Print out the parsed ResponseModel details
      print('Parsed ResponseModel: $responseModel');
      print('Status Code: ${responseModel.statusCode}');
      print('Message: ${responseModel.message}');


      return responseModel;
    } catch (error) {
      // Print the error in case of failure
      print('Error occurred during request reset pass: $error');
      throw error; // Re-throw the error to handle it in the caller
    }
  }
  //delete
  Future<ResponseModel<DeleteResponseModel>> deleteNotes(String id, String accessToken) async {
    try {
      final response = await ApiClient.requestWithAccessToken(
        method: 'DELETE',
        data: id,
        withToken: true,
        url: '/notes/delete-note/$id',
        accessToken: accessToken,
      );

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<DeleteResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          // Make sure data is not null here
          if (data is Map<String, dynamic>) {
            return DeleteResponseModel.fromJson(data);
          } else {
            throw TypeError(); // Handle type error if needed
          }
        },
      );

      return responseModel;
    } catch (error) {
      print('Error occurred during delete request: $error');
      throw error;
    }
  }


  //update note
  Future<ResponseModel<UpdateNoteResponseModel>> updateNote(
      UpdateNoteRequestModel req, String accessToken) async {
    try {
      // Sending API request
      final response = await ApiClient.requestWithAccessToken(
        method: 'PUT',
        data: req.toJson(),
        withToken: true,
        url: '/notes/update-note/${req.id}',
        accessToken: accessToken,
      );

      // Print the raw API response (as a Map)
      print('Raw API Response: ${response.toJson()}');

      // Check the 'data' field in the response
      print('Raw API Data: ${response.toJson()['data']}');

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<UpdateNoteResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          print('Data to be parsed into UpdateNoteResponseModel: $data');
          return UpdateNoteResponseModel.fromJson(data); // Ensure correct parsing
        },
      );

      // Print out the parsed ResponseModel details
      print('Parsed ResponseModel: $responseModel');
      print('Status Code: ${responseModel.statusCode}');
      print('Message: ${responseModel.message}');

      return responseModel;
    } catch (error) {
      // Print the error in case of failure
      print('Error occurred during request update note: $error');
      throw error; // Re-throw the error to handle it in the caller
    }
  }

}