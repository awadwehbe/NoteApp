class DeleteRequestModel {
  final String id;
  final String? accessToken;

  DeleteRequestModel({
    required this.id,
    this.accessToken,  // Make it optional
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accessToken': accessToken,  // Handle nullable value
    };
  }
}
