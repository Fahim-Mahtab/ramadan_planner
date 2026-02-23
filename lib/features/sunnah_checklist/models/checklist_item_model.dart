/// Model representing a checklist item
class ChecklistItemModel {
  final String title;
  bool isCompleted;

  ChecklistItemModel({required this.title, this.isCompleted = false});

  void toggle() {
    isCompleted = !isCompleted;
  }

  ChecklistItemModel copyWith({String? title, bool? isCompleted}) {
    return ChecklistItemModel(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
