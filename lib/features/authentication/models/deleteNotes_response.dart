class DeleteResponseModel {
  final int statusCode;
  final String message;

  DeleteResponseModel({
    required this.statusCode,
    required this.message,
  });

  factory DeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteResponseModel(
      statusCode: json['statusCode'] ?? 0,  // Default value for missing or null
      message: json['message'] ?? '',       // Default value for missing or null
    );
  }
}

