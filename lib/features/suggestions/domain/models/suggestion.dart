class Suggestion {
  final String id;
  final String? title;
  final String? category;
  final String message;
  final String status;
  final bool isAnonymous;
  final DateTime? createdAt;

  const Suggestion({
    required this.id,
    this.title,
    this.category,
    required this.message,
    required this.status,
    required this.isAnonymous,
    this.createdAt,
  });

  factory Suggestion.fromSupabase(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'] as String,
      title: json['title'] as String?,
      category: json['category'] as String?,
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'nueva',
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
