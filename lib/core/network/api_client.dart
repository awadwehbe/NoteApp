import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:note_app/core/network/response_model.dart';


import '../../hive.dart';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class ApiClient {
  static Dio _dio = Dio();
  static bool enableNetworkLog = true;
  static Logger logger = Logger('ApiClient');
  static String baseUrl= 'https://my-notes-app-apis.onrender.com/api';

  static void setDio(Dio dio) {
    _dio = dio;
  }

  // 1- initDio Method
  static void initDio() {
    // Set default options for every request
    _dio.options = BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'en',
      },
    );

    // 2- Interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await SharedPrefsManager.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          logger.info("Request: ${options.uri}, Headers: ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          logger.info("Response: ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) async {
          logger.severe("Error: $error");
          return handler.next(error);
        },
      ),
    );

    // 3- Log interceptors
    if (enableNetworkLog) {
      _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
  }

  // 4- refreshAccessToken Method
  static Future<bool> refreshAccessToken() async {
    String? refreshToken = await SharedPrefsManager.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    try {
      final response = await _dio.post('/auth/refresh-token',
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}));
      ResponseModel responseModel = ResponseModel.fromJson(response.data);
      if (responseModel.statusCode == 200) {
        await SharedPrefsManager.saveAccessToken(responseModel.data['access_token']);
        await SharedPrefsManager.saveRefreshToken(responseModel.data['refresh_token']);
        return true;
      } else {
        logger.severe('Failed to refresh token: ${responseModel.message}');
        return false;
      }
    } catch (e) {
      logger.severe('Error refreshing token: $e');
      return false;
    }
  }

  // 5- request Method
  static Future<ResponseModel> request({
    required String url,
    required String method,
    dynamic data,
    bool withToken = true,
  }) async {
    try {
      final response = await _makeRequest(url: url, method: method, data: data);
      print('Request successful, data: ${response.data}');
      return response;
    } on DioError catch (error) {
      // Log full error details
      print('DioError details: ${error.toString()}');
      if (error.response != null) {
        print('Error response data: ${error.response?.data}');
        print('Error response headers: ${error.response?.headers}');
        print('Error response status code: ${error.response?.statusCode}');
      }

      // Handle specific errors
      if (error.response?.statusCode == 401 && withToken) {
        bool tokenRefreshed = await refreshAccessToken();
        if (tokenRefreshed) {
          return await _makeRequest(url: url, method: method, data: data);
        } else {
          return ResponseModel(
            statusCode: 401,
            message: 'Session expired. Please login again.',
          );
        }
      } else {
        return ResponseModel(
          statusCode: error.response?.statusCode ?? 500,
          message: error.response?.statusMessage ?? 'Something went wrong',
        );
      }
    }
  }


  // 5- _makeRequest method
  static Future<ResponseModel> _makeRequest({
    required String url,
    required String method,
    dynamic data,
  }) async {
    try {
      print('Making request to: $url');
      final response = await _dio.request(
        '$baseUrl$url',
        data: data != null ? jsonEncode(data) : null,
        options: Options(method: method),
      );
      print('Response received: ${response.data}');
      return _handleResponse(response);
    } catch (e) {
      // Log full error details
      if (e is DioError) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('Error response data: ${e.response?.data}');
          print('Error response headers: ${e.response?.headers}');
          print('Error response status code: ${e.response?.statusCode}');
        } else {
          print('Error occurred without response data');
        }
      } else {
        print('Unexpected error: $e');
      }
      // Handle errors with a default response model
      return ResponseModel(
        statusCode: 500,
        message: 'An unexpected error occurred.',
      );
    }
  }


  // 6- handleResponse Method
  static ResponseModel _handleResponse(Response response) {
    final data = response.data;
    return ResponseModel(
      statusCode: data['statusCode'],
      message: data['message'],
      data: data['data'],
    );
  }

  // For no token requests
  static Future<ResponseModel> requestForNoTokensApiReq({
    required String url,
    required String method,
    dynamic data,
  }) async {
    try {
      final response = await _makeRequestForNoTokens(url: url, method: method, data: data);
      return response;
    } on DioError catch (error) {
      logger.severe('DioError: ${error.response?.data ?? error.message}');
      return ResponseModel(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.statusMessage ?? 'Something went wrong',
      );
    }
  }

  static Future<ResponseModel> _makeRequestForNoTokens({
    required String url,
    required String method,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data != null ? jsonEncode(data) : null,
        options: Options(
          method: method,
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      logger.severe('Error occurred during no-token request: $e');
      throw DioError(requestOptions: RequestOptions(path: url));
    }
  }
}


