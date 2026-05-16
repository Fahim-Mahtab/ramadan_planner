/// Model representing a checklist item
class ChecklistItemModel {
  final String title;
  final String? key;
  bool isCompleted;

  ChecklistItemModel({
    required this.title,
    this.key,
    this.isCompleted = false,
  });

  void toggle() {
    isCompleted = !isCompleted;
  }

  ChecklistItemModel copyWith({
    String? title,
    String? key,
    bool? isCompleted,
  }) {
    return ChecklistItemModel(
      title: title ?? this.title,
      key: key ?? this.key,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
