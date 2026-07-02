class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.tags = const [],
  });

  String get dateKey =>
      '${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}';

  JournalEntry copyWith({String? title, String? content, List<String>? tags}) {
    return JournalEntry(
      id: id,
      date: date,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'title': title,
        'content': content,
        'tags': tags,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        tags: (json['tags'] as List?)?.cast<String>() ?? [],
      );
}
