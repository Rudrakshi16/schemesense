import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/scheme_model.dart';

/// API Service for Government Scheme matching
/// Handles all API communication with the scheme matching backend
class ApiService {
  /// Base URL for all API endpoints
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Request timeout duration
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Fetch matching government schemes based on user profile
  /// 
  /// Parameters:
  ///   - age: User's age (required)
  ///   - income: Annual income in rupees (required)
  ///   - occupation: User's occupation (required)
  ///   - gender: User's gender (required)
  ///   - state: State of residence (required)
  /// 
  /// Returns: List<SchemeModel> containing matching schemes
  /// 
  /// Throws:
  ///   - [ApiException] for HTTP errors or parsing failures
  ///   - [TimeoutException] if request exceeds timeout
  static Future<List<SchemeModel>> getSchemes({
    required int age,
    required int income,
    required String occupation,
    required String gender,
    required String state,
  }) async {
    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'age': age,
        'income': income,
        'occupation': occupation,
        'gender': gender,
        'state': state,
      };

      // Make POST request
      final response = await http
          .post(
            Uri.parse('$baseUrl/get-schemes'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(timeoutDuration);

      // Handle response status codes
      if (response.statusCode == 200) {
        return _parseSchemeList(response.body);
      } else if (response.statusCode == 400) {
        throw ApiException(
          'Bad Request: Invalid input parameters',
          statusCode: 400,
        );
      } else if (response.statusCode == 401) {
        throw ApiException(
          'Unauthorized: Authentication required',
          statusCode: 401,
        );
      } else if (response.statusCode == 500) {
        throw ApiException(
          'Server Error: Please try again later',
          statusCode: 500,
        );
      } else {
        throw ApiException(
          'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException(
        'Network Error: ${e.message}',
        originalException: e,
      );
    } on FormatException catch (e) {
      throw ApiException(
        'Response Format Error: ${e.message}',
        originalException: e,
      );
    } catch (e) {
      throw ApiException(
        'Unexpected Error: $e',
        originalException: e,
      );
    }
  }

  /// Parse JSON response into List<SchemeModel>
  /// 
  /// Parameters:
  ///   - responseBody: Raw JSON response body as String
  /// 
  /// Returns: List<SchemeModel>
  /// 
  /// Throws: [ApiException] if JSON parsing fails
  static List<SchemeModel> _parseSchemeList(String responseBody) {
    try {
      final dynamic jsonData = jsonDecode(responseBody);

      // Handle different response formats
      if (jsonData is List) {
        return jsonData
            .map((item) => SchemeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (jsonData is Map && jsonData.containsKey('schemes')) {
        final List<dynamic> schemes = jsonData['schemes'] as List<dynamic>;
        return schemes
            .map((item) => SchemeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Unexpected response format: Expected list or object with "schemes" key',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to parse schemes: $e',
        originalException: e,
      );
    }
  }
}

/// Custom Exception for API errors
/// Provides detailed error information for debugging and user feedback
class ApiException implements Exception {
  /// Error message
  final String message;

  /// HTTP status code (if applicable)
  final int? statusCode;

  /// Original exception (if caught from another source)
  final Object? originalException;

  /// Constructor for ApiException
  ApiException(
    this.message, {
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException [$statusCode]: $message';
    }
    return 'ApiException: $message';
  }
}
