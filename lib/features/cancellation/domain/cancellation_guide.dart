class CancellationGuide {
  const CancellationGuide({
    required this.merchantLabel,
    required this.instructions,
    required this.estimatedTime,
    required this.notes,
    this.officialUrl,
    this.includeMessage = true,
  });

  final String merchantLabel;
  final Uri? officialUrl;
  final String instructions;
  final String estimatedTime;
  final String notes;
  final bool includeMessage;

  bool get canOpenPage => officialUrl != null;

  /// Merchant-specific caveat that is not the repeated cancel disclaimer.
  String? get extraNotes => extraNotesFrom(notes);

  static String? extraNotesFrom(String notes) {
    final extra = notes
        .split(RegExp(r'(?<=\.)\s+'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .where((part) {
          final lower = part.toLowerCase();
          return !lower.contains('does not cancel') &&
              !lower.contains('you must finish');
        })
        .join(' ');
    return extra.isEmpty ? null : extra;
  }
}
