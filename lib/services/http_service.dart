import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction_model.dart';

/// HTTP Service for making API calls
/// Handles all network requests with proper error handling
class HttpService {
  /// Base URL for API endpoints
  static const String baseUrl = 'https://api.example.com';
  
  /// HTTP client timeout duration
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Fetch all transactions from API
  /// Returns a list of [Transaction] objects
  static Future<List<Transaction>> fetchTransactions() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/transactions'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  /// Fetch a single transaction by ID
  static Future<Transaction> fetchTransactionById(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/transactions/$id'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return Transaction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transaction: $e');
    }
  }

  /// Create a new transaction
  static Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/transactions'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(transaction.toJson()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return Transaction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating transaction: $e');
    }
  }

  /// Update an existing transaction
  static Future<Transaction> updateTransaction(
    String id,
    Transaction transaction,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/transactions/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(transaction.toJson()),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return Transaction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating transaction: $e');
    }
  }

  /// Delete a transaction
  static Future<void> deleteTransaction(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/transactions/$id'))
          .timeout(timeoutDuration);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting transaction: $e');
    }
  }
}
