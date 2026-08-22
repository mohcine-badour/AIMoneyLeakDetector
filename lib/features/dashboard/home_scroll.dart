import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScrollToTopProvider = NotifierProvider<HomeScrollToTop, int>(
  HomeScrollToTop.new,
);

class HomeScrollToTop extends Notifier<int> {
  @override
  int build() => 0;

  void request() => state++;
}
