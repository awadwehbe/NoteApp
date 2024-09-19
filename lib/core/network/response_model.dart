class ResponseModel<T> {
  final int statusCode;
  final String message;
  final T? data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? createData,
  }) {
    return ResponseModel<T>(
      // Ensure that the statusCode is non-null, provide a default value of 500 if it is null
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'No message',
      data: (json['data'] != null && createData != null)
          ? createData(json['data'])
          : null, // Handle the case where 'data' is null
    );
  }

  factory ResponseModel.fromJsonWithData(Map<String, dynamic> json,
      T Function(Map<String, dynamic>) createData,) {
    return ResponseModel<T>(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'No message',
      data: json['data'] != null ? createData(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson({Map<String, dynamic> Function(T)? dataToJson}) {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data != null && dataToJson != null ? dataToJson(data!) : data,
    };
  }
}


