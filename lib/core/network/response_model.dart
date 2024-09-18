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
  /*
   in api client we have:
  ResponseModel responseModel = ResponseModel.fromJson(response.data);// so here we have only data
  while in repository we have:
  return ResponseModel<SignupResponseModel>.fromJson(
      response.toJson(),
        createData:(data) => SignupResponseModel.fromJson(data),
    );
    we invoke 2 parameters here isntead of 1 so the solution is to make the second parameter optional

    This solution provides flexibility, allowing the method to be used with or without the createData parameter,
    depending on whether or not it's needed to transform the data.

    T Function(Map<String, dynamic>)? createData: This makes createData an optional parameter.
If createData is provided, it will be used to transform the data field.
If createData is not provided, the data will simply be cast as T without any transformation.
   */

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

