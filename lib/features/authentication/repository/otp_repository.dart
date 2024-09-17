import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/otp_request.dart';
import '../models/otp_response.dart';

class OtpRepository {
  /// Sign-up method for registering a new user
  Future<ResponseModel<OtpResponseModel>> Otpval(
      OtpRequestModel otpRequest) async {
    final response = await ApiClient.request(
      method: 'POST',
      data: otpRequest.toJson(),
      withToken: false,
      url: '/auth/verify-email',
    );

    // Print the raw response for debugging
    print('Raw Response: ${response.toJson()}');

    var responseModel = ResponseModel<OtpResponseModel>.fromJson(
      response.toJson(),
      createData: (data) {
        print('Data to be parsed: $data');
        return OtpResponseModel.fromJson(data);
      },
    );

    print('ResponseModel: ${responseModel.toString()}');
    print('Status: ${responseModel.statusCode}');
    print('Message: ${responseModel.message}');

    return responseModel;
  }

}