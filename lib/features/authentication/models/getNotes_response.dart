class Note {
  String? id;
  String? category;
  String? title;
  String? text;
  String? user;

  Note({
    this.id,
    this.category,
    this.title,
    this.text,
    this.user,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    print('Parsing Note: $json');
    return Note(
      id: json['_id'],
      category: json['category'],
      title: json['title'],
      text: json['text'],
      user: json['user'],
    );
  }
}

class NotesResponseModel {
  int? statusCode;
  String? message;
  List<Note>? notes;

  NotesResponseModel({
    this.statusCode,
    this.message,
    this.notes,
  });

  factory NotesResponseModel.fromJson(Map<String, dynamic> json) {
    var notesJson = json['notes'] as List?; // Look directly inside 'notes'
    print('Notes JSON: $notesJson');

    return NotesResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      notes: notesJson != null ? notesJson.map((e) => Note.fromJson(e)).toList() : [],
    );
  }
}
