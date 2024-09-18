class ReqpassResetResponseModel {
  final int statusCode;
  final String message;

  ReqpassResetResponseModel({required this.statusCode, required this.message});

  // Factory method to create an instance from JSON
  factory ReqpassResetResponseModel.fromJson(Map<String, dynamic> json) {
    return ReqpassResetResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
//ReqpassResetResponseModel