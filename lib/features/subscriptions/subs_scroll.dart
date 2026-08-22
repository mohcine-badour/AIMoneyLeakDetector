import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionsScrollToTopProvider =
    NotifierProvider<SubscriptionsScrollToTop, int>(
      SubscriptionsScrollToTop.new,
    );

class SubscriptionsScrollToTop extends Notifier<int> {
  @override
  int build() => 0;

  void request() => state++;
}
