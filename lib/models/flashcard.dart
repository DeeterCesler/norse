class Flashcard {
  final String norse;
  final String english;
  final int index;
  final List<String> era;
  final List<String> subtype;

  Flashcard({
    required this.norse,
    required this.english,
    required this.index,
    required this.era,
    required this.subtype,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map, int index) {
    return Flashcard(
      norse: map['norse']!,
      english: map['english']!,
      index: index,
      era: List<String>.from(map['era'] ?? []),
      subtype: List<String>.from(map['subtype'] ?? []),
    );
  }
}
