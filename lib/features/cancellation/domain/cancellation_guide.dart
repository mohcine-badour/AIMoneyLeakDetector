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
}
