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
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiryTime; // Add this field if the expiry time is provided by the API
  final User? user;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.expiryTime,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiryTime: json.containsKey('expiryTime')
          ? DateTime.parse(json['expiryTime']) // Assuming expiryTime is in a parseable format
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
