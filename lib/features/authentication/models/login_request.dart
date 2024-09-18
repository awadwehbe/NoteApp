class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  // Convert this object into a JSON map to send to the API
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
