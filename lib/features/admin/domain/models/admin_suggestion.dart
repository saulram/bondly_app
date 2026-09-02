class AdminSuggestion {
  final String id;
  final String? title;
  final String? category;
  final String message;
  final String status;
  final bool isAnonymous;
  final String? adminNote;
  final DateTime? createdAt;
  final String? authorName;

  const AdminSuggestion({
    required this.id,
    this.title,
    this.category,
    required this.message,
    required this.status,
    required this.isAnonymous,
    this.adminNote,
    this.createdAt,
    this.authorName,
  });

  factory AdminSuggestion.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return AdminSuggestion(
      id: json['id'] as String,
      title: json['title'] as String?,
      category: json['category'] as String?,
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'nueva',
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      adminNote: json['admin_note'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      authorName: author?['complete_name'] as String?,
    );
  }
}
