import 'package:flutter_riverpod/flutter_riverpod.dart';

final insightsScrollToTopProvider =
    NotifierProvider<InsightsScrollToTop, int>(InsightsScrollToTop.new);

class InsightsScrollToTop extends Notifier<int> {
  @override
  int build() => 0;

  void request() => state++;
}
