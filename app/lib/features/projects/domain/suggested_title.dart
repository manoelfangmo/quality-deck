/// Last word of the client name, an en dash, then the street.
/// "Ana Melgar" + "123 Oak St" → "Melgar – 123 Oak St".
String suggestedTitle(String clientName, String street) {
  final parts = clientName
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  final lastName = parts.isEmpty ? '' : parts.last;
  final streetTrim = street.trim();
  final raw = streetTrim.isEmpty
      ? lastName
      : lastName.isEmpty
      ? streetTrim
      : '$lastName – $streetTrim';
  if (raw.length <= 120) return raw;
  return raw.substring(0, 120);
}
