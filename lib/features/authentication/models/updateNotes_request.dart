class UpdateNoteRequestModel {
  final String id;
  final String title;
  final String text;
  final String category;
  final String accessToken;

  UpdateNoteRequestModel({
    required this.id,
    required this.title,
    required this.text,
    required this.category,
    required this.accessToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'category': category,
      // Optionally include 'accessToken' if needed
    };
  }
}
