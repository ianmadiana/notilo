class NotesModel {
  NotesModel({
    required this.id,
    required this.title,
    required this.note,
    required this.imageUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String note;
  final String imageUrl;
  final DateTime createdAt;
}
