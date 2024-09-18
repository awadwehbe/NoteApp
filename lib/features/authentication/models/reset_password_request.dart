class ResetPasswordRequestModel {
  final String email;
  final String code;
  final String newPassword;

  ResetPasswordRequestModel({
  required this.email,
  required this.code,
  required this.newPassword,
  });

  Map<String, dynamic> toJson() {
  return {
  'email': email,
  'code': code,
  'newPassword': newPassword,
  };
  }
  }

