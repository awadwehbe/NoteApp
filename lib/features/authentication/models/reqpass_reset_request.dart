
class ReqpassResetRequesetModel {
  final String email;

  ReqpassResetRequesetModel({required this.email});

  // Convert to JSON for the request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}