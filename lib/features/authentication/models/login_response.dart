class User {
  final String firstName;
  final String lastName;
  final String email;
  final bool isVerified;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isVerified,
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

class LoginResponseModel {
  final User user;
  final String accessToken;
  final String refreshToken;

  LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: User.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}

class LoginResponse {
  final int statusCode;
  final String message;
  final LoginResponseModel? data;

  LoginResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? LoginResponseModel.fromJson(json['data'])
          : null,
    );
  }
}
