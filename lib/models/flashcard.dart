class Flashcard {
  final String norse;
  final String english;
  final int index;

  Flashcard({
    required this.norse,
    required this.english,
    required this.index,
  });

  factory Flashcard.fromMap(Map<String, dynamic> map, int index) {
    return Flashcard(
      norse: map['norse']!,
      english: map['english']!,
      index: index,
    );
  }
}
