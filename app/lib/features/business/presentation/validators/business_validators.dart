abstract final class BusinessValidators {
  static String? businessName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > 80) {
      return 'Enter a business name (up to 80 characters).';
    }
    return null;
  }
}
