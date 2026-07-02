class IslamicEvent {
  final String title;
  final String description;
  final int hijriDay;
  final int hijriMonth;
  final EventType type;

  const IslamicEvent({
    required this.title,
    required this.description,
    required this.hijriDay,
    required this.hijriMonth,
    required this.type,
  });
}

enum EventType {
  religious,
  historical,
  recommended;

  String get label => switch (this) {
        EventType.religious => 'Religious',
        EventType.historical => 'Historical',
        EventType.recommended => 'Recommended',
      };
}
