/// Model representing a single Salah (prayer)
class SalahModel {
  final String name;
  bool isCompleted;

  SalahModel({required this.name, this.isCompleted = false});

  void toggle() {
    isCompleted = !isCompleted;
  }

  SalahModel copyWith({String? name, bool? isCompleted}) {
    return SalahModel(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
