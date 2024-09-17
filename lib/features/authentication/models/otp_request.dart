class OtpRequestModel {
  String? email;
  String? code;

  OtpRequestModel({this.email, this.code});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "code": code,
    };
  }
}
