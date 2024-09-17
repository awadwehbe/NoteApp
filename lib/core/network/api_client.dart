import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:note_app/core/network/response_model.dart';


import '../../hive.dart';

class ApiClient{
 static Dio _dio=Dio();
static bool enableNetworkLog=true;
 static Logger logger = Logger();

 //1- initDio Method

 static void initDio(){//we use initDio to initiate and set default option for every request
   _dio.options=BaseOptions(
     baseUrl: 'https://my-notes-app-apis.onrender.com/api',
     connectTimeout:Duration(seconds: 5) ,
     receiveTimeout:Duration(seconds: 3) ,
     headers: {
       'Content-Type': 'application/json',
       'Accept-Language': 'en',}
   );
   //2-interceptors
   _dio.interceptors.add(
     InterceptorsWrapper(//a widget that help us to create interceptors, we have 3 cases(onRequest,onResponse and onError)
       onRequest: (options,handler)async{// it has options and handler to handle the options of each request
         String? accessToken= await SharedPrefsManager.getAccessToken();//we get the access token saved in the sharedPref
         if(accessToken!=null && accessToken.isNotEmpty)
           //when we have accessToken and we are sending data we attach the accessToken to the authorization header
           options.headers['Authorization'] = 'Bearer $accessToken';
         logger.i("Request: ${options.uri}, Headers: ${options.headers}");
         return handler.next(options);
       },
       onResponse:(response,handler)async{
         logger.i("Response: ${response.data}");
         return handler.next(response);
       } ,
       onError:(error,handler)async{
         logger.e("Error: $error");
         return handler.next(error);
       } ,
     )
   );
//3- log interceptors
   if (enableNetworkLog) {
     _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
   }
 }
   //4-refreshAccessToken Method
   //When the access token expires, this method uses the refresh token to get a new access token.
   static Future<bool> refreshAccessToken() async {
     String?  refreshToken = await SharedPrefsManager.getRefreshToken();
     if(refreshToken==null || refreshToken.isEmpty){
       return false;
     }
     try{
       final response= await _dio.post('/auth/refresh-token',
       options: Options(headers: {'Authorization': 'Bearer $refreshToken'})
       );
       ResponseModel responseModel = ResponseModel.fromJson(response.data);
       if (responseModel.statusCode == 200) {
         await SharedPrefsManager.saveAccessToken(responseModel.data['access_token']);
         await SharedPrefsManager.saveRefreshToken(responseModel.data['refresh_token']);
         return true;
         //status code 200 show that i get new tokens and i savethem in the pref
       }
       else {// else i fail to refresh the token
         logger.e('Failed to refresh token: ${responseModel.message}');
         return false;
       }
     } catch (e) {
       logger.e('Error refreshing token: $e');
       return false;
     }
   }
   //5-request Method
 static Future<ResponseModel> request({
   required String url,
   required String method,
   dynamic data,
   bool withToken = true,
 }) async {
   try {
     final response = await _makeRequest(url: url, method: method, data: data);
     return response;
   } on DioError catch (error) {
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
       return ResponseModel(statusCode: 500, message: 'Something went wrong');
     }
   }
 }
 //withToken: Indicates whether the request requires token handling.(if require we give it token)

//5-makerequest method
  static Future<ResponseModel> _makeRequest({
    required String url,
    required String method,
    dynamic data,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data != null ? jsonEncode(data) : null,
        options: Options(method: method),
      );
      return _handleResponse(response);
    } catch (e) {
      logger.e(e);
      throw DioError(requestOptions: RequestOptions(path: url));
    }
  }

  //6-handle response

  static ResponseModel _handleResponse(Response response) {
    final data = response.data;
    return ResponseModel(
      statusCode: data['statusCode'],
      message: data['message'],
      data: data['data'],
    );
  }
/*
Converts the raw API response into a ResponseModel object, which standardizes the handling of statusCode, message, and data from the
 server.
 */






}

