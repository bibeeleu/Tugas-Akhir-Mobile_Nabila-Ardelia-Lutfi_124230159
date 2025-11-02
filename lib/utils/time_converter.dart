DateTime convertTime({
  required String fromZone,
  required String toZone,
  required int hour,
  required int minute,
}) {
  final Map<String, int> offsets = {
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
    'London': 0,
    'Jepang': 9,
  };

  int diff = offsets[toZone]! - offsets[fromZone]!;
  return DateTime(2025, 1, 1, hour, minute).add(Duration(hours: diff));
}

String formatTime(DateTime dateTime) {
  return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}
