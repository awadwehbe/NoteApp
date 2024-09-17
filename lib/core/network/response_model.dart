/// General Response Model to handle API responses
class ResponseModel<T> {
  final int statusCode;
  final String message;
  final T? data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  /// Factory method that accepts only one argument (when no custom `createData` is needed)
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? json['data'] as T : null, // Generic data
    );
  }

  /// Factory method that accepts a second argument `createData` for parsing specific types
  factory ResponseModel.fromJsonWithData(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) createData,
      ) {
    return ResponseModel<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? createData(json['data']) : null,
    );
  }
}