/// Data model for Transaction
/// Used throughout the app to represent transaction objects
class Transaction {
  final String id;
  final String title;
  final String amount;
  final String category;
  final DateTime timestamp;
  final bool isDebit;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.timestamp,
    required this.isDebit,
    this.description,
  });

  /// Factory constructor to create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as String,
      category: json['category'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isDebit: json['isDebit'] as bool,
      description: json['description'] as String?,
    );
  }

  /// Convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
      'isDebit': isDebit,
      'description': description,
    };
  }
}
