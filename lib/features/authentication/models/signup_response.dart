class SignupResponseModel {
  final int? statusCode;
  final String? message;
  final SignupUserData? data;

  SignupResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  // Factory constructor to create a SignupResponseModel from JSON
  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? SignupUserData.fromJson(json['data']) : null,
    );
  }
}

class SignupUserData {
  final String firstName;
  final String lastName;
  final String email;

  SignupUserData({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // Factory constructor to create SignupUserData from JSON
  factory SignupUserData.fromJson(Map<String, dynamic> json) {
    return SignupUserData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}