class CreateNoteResponseModel {
  final int statusCode;
  final String message;
  final NoteData? data;

  CreateNoteResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  // Factory constructor to create an instance from JSON
  factory CreateNoteResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateNoteResponseModel(
      statusCode: json['statusCode'] ?? 0, // Default to 0 if null
      message: json['message'] ?? 'No message', // Default to a fallback value
      data: json['data'] != null ? NoteData.fromJson(json['data']) : null,
    );
  }

}

class NoteData {
  final String id;
  final String category;
  final String title;
  final String text;
  final String user;

  NoteData({
    required this.id,
    required this.category,
    required this.title,
    required this.text,
    required this.user,
  });

  // Factory constructor to create an instance from JSON
  factory NoteData.fromJson(Map<String, dynamic> json) {
    return NoteData(
      id: json['_id'],
      category: json['category'],
      title: json['title'],
      text: json['text'],
      user: json['user'],
    );
  }
}