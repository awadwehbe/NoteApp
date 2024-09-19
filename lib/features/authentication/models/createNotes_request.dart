class CreateNoteRequestModel {
  final String category;
  final String title;
  final String text;

  CreateNoteRequestModel({
    required this.category,
    required this.title,
    required this.text,
  });

  // Convert the object to a JSON format that can be sent in a request
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'text': text,
    };
  }
}