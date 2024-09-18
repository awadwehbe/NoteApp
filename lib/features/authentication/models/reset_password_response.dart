class ResetPasswordResponseModel {
  final int statusCode;
  final String message;

  ResetPasswordResponseModel({
  required this.statusCode,
  required this.message,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
  return ResetPasswordResponseModel(
  statusCode: json['statusCode'],
  message: json['message'],
  );
  }
  }
