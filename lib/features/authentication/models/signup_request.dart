class SignupRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignupRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}

