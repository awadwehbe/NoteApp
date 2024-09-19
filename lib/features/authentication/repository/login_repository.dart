
import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../../../hive.dart';
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
        withToken: false, // Token not needed for login request
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

      // Store tokens and expiry time
      if (responseModel.data?.accessToken != null) {
        await SharedPrefsManager.saveAccessToken(responseModel.data!.accessToken!);
      }

      if (responseModel.data?.refreshToken != null) {
        await SharedPrefsManager.saveRefreshToken(responseModel.data!.refreshToken!);
      }

      // Assuming a default expiry time of 1 hour for simplicity
      // Adjust this if you have specific expiry times
      await SharedPrefsManager.storeAccessToken(responseModel.data!.accessToken!,
          Duration(hours: 1));

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

  /// Check if the access token is expired
  Future<bool> isAccessTokenExpired() async {
    return await SharedPrefsManager.isTokenExpired();
  }

  /// Refresh the access token if expired
  Future<void> refreshTokenIfExpired() async {
    if (await isAccessTokenExpired()) {
      final refreshToken = await SharedPrefsManager.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Call the API to refresh the access token
          final response = await ApiClient.request(
            method: 'POST',
            data: {'refreshToken': refreshToken},
            withToken: false, // Refresh token request does not require access token
            url: '/auth/refresh',
          );

          // Handle response and update tokens
          var responseModel = ResponseModel<LoginResponseModel>.fromJson(
            response.toJson(),
            createData: (data) {
              return LoginResponseModel.fromJson(data); // Ensure correct parsing
            },
          );

          if (responseModel.data?.accessToken != null) {
            await SharedPrefsManager.saveAccessToken(responseModel.data!.accessToken!);
          }

          if (responseModel.data?.refreshToken != null) {
            await SharedPrefsManager.saveRefreshToken(responseModel.data!.refreshToken!);
          }

          // Update expiry time
          await SharedPrefsManager.storeAccessToken(responseModel.data!.accessToken!,
              Duration(hours: 1));

        } catch (error) {
          print('Error occurred during token refresh: $error');
          // Handle refresh token error (e.g., prompt user to log in again)
        }
      }
    }
  }
}




