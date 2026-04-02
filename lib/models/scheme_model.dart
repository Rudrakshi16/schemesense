/// Data model for Government Scheme
/// Contains all information about a government scheme including eligibility,
/// benefits, and application requirements
class SchemeModel {
  final String schemeName;
  final bool eligible;
  final String matchType;
  final double confidenceScore;
  final String matchReason;
  final String benefits;
  final String applicationLink;
  final List<String> documentsRequired;
  final List<String> category;

  /// Constructor for SchemeModel
  SchemeModel({
    required this.schemeName,
    required this.eligible,
    required this.matchType,
    required this.confidenceScore,
    required this.matchReason,
    required this.benefits,
    required this.applicationLink,
    required this.documentsRequired,
    required this.category,
  });

  /// Factory constructor to create SchemeModel from JSON
  /// Handles type conversion and null safety
  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      schemeName: json['scheme_name'] as String? ?? '',
      eligible: json['eligible'] as bool? ?? false,
      matchType: json['match_type'] as String? ?? '',
      confidenceScore: _parseDouble(json['confidence_score']),
      matchReason: json['match_reason'] as String? ?? '',
      benefits: json['benefits'] as String? ?? '',
      applicationLink: json['application_link'] as String? ?? '',
      documentsRequired: _parseStringList(json['documents_required']),
      category: _parseStringList(json['category']),
    );
  }

  /// Convert SchemeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'scheme_name': schemeName,
      'eligible': eligible,
      'match_type': matchType,
      'confidence_score': confidenceScore,
      'match_reason': matchReason,
      'benefits': benefits,
      'application_link': applicationLink,
      'documents_required': documentsRequired,
      'category': category,
    };
  }

  /// Helper method to parse confidence_score as double
  /// Handles String, int, double, and null values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Helper method to parse List<String>
  /// Handles dynamic list and null values
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List<String>) return value;
    if (value is List) {
      return value
          .map((item) => item.toString())
          .toList();
    }
    return [];
  }

  /// Create a copy of SchemeModel with modified fields
  SchemeModel copyWith({
    String? schemeName,
    bool? eligible,
    String? matchType,
    double? confidenceScore,
    String? matchReason,
    String? benefits,
    String? applicationLink,
    List<String>? documentsRequired,
    List<String>? category,
  }) {
    return SchemeModel(
      schemeName: schemeName ?? this.schemeName,
      eligible: eligible ?? this.eligible,
      matchType: matchType ?? this.matchType,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      matchReason: matchReason ?? this.matchReason,
      benefits: benefits ?? this.benefits,
      applicationLink: applicationLink ?? this.applicationLink,
      documentsRequired: documentsRequired ?? this.documentsRequired,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'SchemeModel('
        'schemeName: $schemeName, '
        'eligible: $eligible, '
        'matchType: $matchType, '
        'confidenceScore: $confidenceScore, '
        'matchReason: $matchReason, '
        'benefits: $benefits, '
        'applicationLink: $applicationLink, '
        'documentsRequired: $documentsRequired, '
        'category: $category)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemeModel &&
          runtimeType == other.runtimeType &&
          schemeName == other.schemeName &&
          eligible == other.eligible &&
          matchType == other.matchType &&
          confidenceScore == other.confidenceScore &&
          matchReason == other.matchReason &&
          benefits == other.benefits &&
          applicationLink == other.applicationLink &&
          documentsRequired == other.documentsRequired &&
          category == other.category;

  @override
  int get hashCode =>
      schemeName.hashCode ^
      eligible.hashCode ^
      matchType.hashCode ^
      confidenceScore.hashCode ^
      matchReason.hashCode ^
      benefits.hashCode ^
      applicationLink.hashCode ^
      documentsRequired.hashCode ^
      category.hashCode;
}
