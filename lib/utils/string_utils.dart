// lib/utils/string_utils.dart
String formatName(String fullName) {
  final parts = fullName.trim().split(' ');
  if (parts.isEmpty) return '';
  if (parts.length == 1) return parts.first; // só 1 nome
  return '${parts.first} ${parts.last}';
}
