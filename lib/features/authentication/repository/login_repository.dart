
import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepository {
  /// Login method for signing in a user
  Future<ResponseModel<LoginResponseModel>> login(
      LoginRequestModel loginRequest) async {
    try {
      // Print the login request details
      print('Login Request: ${loginRequest.toJson()}');

      // Sending API request
      final response = await ApiClient.request(
        method: 'POST',
        data: loginRequest.toJson(),
        withToken: false,
        url: '/auth/signin',
      );

      // Print the raw API response (as a Map)
      print('Raw API Response: ${response.toJson()}');

      // Check the 'data' field in the response
      print('Raw API Data: ${response.toJson()['data']}');

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<LoginResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          print('Data to be parsed into LoginResponseModel: $data');
          return LoginResponseModel.fromJson(data); // Ensure correct parsing
        },
      );


      // Print out the parsed ResponseModel details
      print('Parsed ResponseModel: $responseModel');
      print('Status Code: ${responseModel.statusCode}');
      print('Message: ${responseModel.message}');
      print('Login Response Data: ${responseModel.data}');

      // Check for null values in the user or data fields
      if (responseModel.data?.user == null) {
        print('Error: User or some user data is null');
      }

      return responseModel;
    } catch (error) {
      // Print the error in case of failure
      print('Error occurred during login: $error');
      throw error; // Re-throw the error to handle it in the caller
    }
  }
}

