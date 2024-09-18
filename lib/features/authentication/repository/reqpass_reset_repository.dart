import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/reqpass_reset_request.dart';
import '../models/reqpass_reset_response.dart';

class ReqpassResetRepository {
  /// Login method for signing in a user
  Future<ResponseModel<ReqpassResetResponseModel>> login(
      ReqpassResetRequesetModel ReqpassResetRequest) async {
    try {
      // Print the login request details
      print('ReqpassReset Request: ${ReqpassResetRequest.toJson()}');

      // Sending API request
      final response = await ApiClient.request(
        method: 'POST',
        data: ReqpassResetRequest.toJson(),
        withToken: false,
        url: '/auth/request-password-reset',
      );

      // Print the raw API response (as a Map)
      print('Raw API Response: ${response.toJson()}');

      // Check the 'data' field in the response
      print('Raw API Data: ${response.toJson()['data']}');

      // Parse the response into ResponseModel
      var responseModel = ResponseModel<ReqpassResetResponseModel>.fromJson(
        response.toJson(),
        createData: (data) {
          print('Data to be parsed into ReqpassResetResponseModel: $data');
          return ReqpassResetResponseModel.fromJson(data); // Ensure correct parsing
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
}
