import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/signup_request.dart';
import '../models/signup_response.dart';

/// Repository class to handle all user-related API calls
class UserRepository {
  /// Sign-up method for registering a new user
  Future<ResponseModel<SignupResponseModel>> signUp(
      SignupRequestModel signupRequest) async {
    final response = await ApiClient.request(
      method: 'POST',
      data: signupRequest.toJson(),
      withToken: false,
      url: '/auth/signup',
    );

    // Print the raw response for debugging
    print('Raw Response: ${response.toJson()}');

    var responseModel = ResponseModel<SignupResponseModel>.fromJson(
      response.toJson(),
      createData: (data) {
        print('Data to be parsed: $data');
        return SignupResponseModel.fromJson(data);
      },
    );

    print('ResponseModel: ${responseModel.toString()}');
    print('Status: ${responseModel.statusCode}');
    print('Message: ${responseModel.message}');

    return responseModel;
  }

}
/*
 ResponseModel<SignupResponseModel> this statement mean that i expect that response model
  contains data of type SignupResponseModel.

  (data) => SignupResponseModel.fromJson(data)
  This is a function (often called a callback function) that you pass to the fromJson method to
  tell it how to transform the raw data part of the JSON into an actual SignupResponseModel object.

 */
