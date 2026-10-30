String normalizeInviteCode(String code) {
  return code.trim().toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
}
