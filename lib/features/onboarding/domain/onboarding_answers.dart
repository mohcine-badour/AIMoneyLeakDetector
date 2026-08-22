enum SpendingRange { under25, from25to50, from50to100, from100to200, over200 }

enum SavingsGoal { amount25, amount50, amount100, amount200 }

enum OnboardingEntryPath { addManually, scanReceipt, importLater }

class OnboardingAnswers {
  const OnboardingAnswers({
    required this.spendingRange,
    required this.savingsGoal,
    required this.entryPath,
    required this.completedAt,
  });

  final SpendingRange spendingRange;
  final SavingsGoal savingsGoal;
  final OnboardingEntryPath entryPath;
  final DateTime completedAt;
}

