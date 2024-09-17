class OtpResponseModel {
  int? statusCode;
  String? message;
  UserData? data; // Only if statusCode is 200

  OtpResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  User? user;
  String? accessToken;
  String? refreshToken;

  UserData({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

class User {
  String? firstName;
  String? lastName;
  String? email;
  bool? isVerified;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isVerified: json['isVerified'],
    );
  }
}
