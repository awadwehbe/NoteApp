class ResponseModel<T> {
  final int statusCode;
  final String message;
  final T? data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  /// Factory method to create a ResponseModel from JSON with optional custom data parsing
  factory ResponseModel.fromJson(
      Map<String, dynamic> json, {
        T Function(Map<String, dynamic>)? createData,
      }) {
    return ResponseModel<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] != null && createData != null)
          ? createData(json['data'])
          : json['data'] as T?,
    );
  }

  /// Factory method to create a ResponseModel from JSON with required custom data parsing
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

  /// Converts the ResponseModel into a JSON-compatible map
  Map<String, dynamic> toJson({Map<String, dynamic> Function(T)? dataToJson}) {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data != null && dataToJson != null ? dataToJson(data!) : data,
    };
  }
}

