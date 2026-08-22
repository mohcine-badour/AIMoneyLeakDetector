import '../../../app/config/app_config.dart';
import '../domain/analytics.dart';
import 'disabled_analytics.dart';
import 'logging_analytics.dart';

abstract final class AnalyticsFactory {
  static Analytics create({bool enabled = AppConfig.analyticsEnabled}) {
    if (!enabled) {
      return const DisabledAnalytics();
    }
    return const SanitizingAnalytics(LoggingAnalytics());
  }
}
