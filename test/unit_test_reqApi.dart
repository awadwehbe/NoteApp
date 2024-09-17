import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:note_app/core/network/api_client.dart';
// Replace with your actual file path


// Mock class
class MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      ApiClient.setDio(mockDio); // Use the mock Dio instance
    });

    test('successful request returns valid data', () async {
      // Arrange
      final mockResponse = Response(
        data: {
          'statusCode': 200,
          'message': 'Success',
          'data': {'key': 'value'}
        },
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
      );

      // Mock the request method
      when(mockDio.request(
        '/test',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await ApiClient.request(
        url: '/test',
        method: 'GET',
        withToken: false,
      );

      // Assert
      expect(result.statusCode, 200);
      expect(result.message, 'Success');
      expect(result.data, {'key': 'value'});
    });

    test('request handles DioError with 401 status code', () async {
      // Arrange
      when(mockDio.request(
        '/test',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioError(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      // Mock token refresh function
      when(ApiClient.refreshAccessToken()).thenAnswer((_) async => true);

      // Act
      final result = await ApiClient.request(
        url: '/test',
        method: 'GET',
      );

      // Assert
      expect(result.statusCode, 401);
      expect(result.message, 'Session expired. Please login again.');
    });

    test('request handles DioError with other status codes', () async {
      // Arrange
      when(mockDio.request(
        '/test',
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioError(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
        ),
      ));

      // Act
      final result = await ApiClient.request(
        url: '/test',
        method: 'GET',
      );

      // Assert
      expect(result.statusCode, 500);
      expect(result.message, 'Something went wrong');
    });
  });
}
