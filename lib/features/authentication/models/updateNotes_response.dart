class UpdateNoteResponseModel {
  final int statusCode;
  final String message;
  final Note? data;

  UpdateNoteResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UpdateNoteResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateNoteResponseModel(
      statusCode: json['statusCode'] ?? 0,  // Provide a default value for null
      message: json['message'] ?? '',  // Provide a default value for null
      data: json['data'] != null ? Note.fromJson(json['data']) : null,
    );
  }
}

class Note {
  final String id;
  final String category;
  final String title;
  final String text;
  final String user;

  Note({
    required this.id,
    required this.category,
    required this.title,
    required this.text,
    required this.user,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      category: json['category'],
      title: json['title'],
      text: json['text'],
      user: json['user'],
    );
  }
}