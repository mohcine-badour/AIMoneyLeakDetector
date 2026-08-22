import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/insights_timeframe.dart';

Future<InsightsTimeframe?> showTimeframeMenu({
  required BuildContext context,
  required InsightsTimeframe current,
}) {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS) {
    return _showIos(context, current);
  }
  return _showAndroid(context, current);
}

Future<InsightsTimeframe?> _showIos(
  BuildContext context,
  InsightsTimeframe current,
) {
  return showCupertinoModalPopup<InsightsTimeframe>(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: const Text(AppStrings.timeframeTitle),
        actions: [
          for (final value in InsightsTimeframe.values)
            CupertinoActionSheetAction(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop(value);
              },
              child: Text(
                value == current ? '✓ ${value.label}' : value.label,
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
      );
    },
  );
}

Future<InsightsTimeframe?> _showAndroid(
  BuildContext context,
  InsightsTimeframe current,
) {
  return showModalBottomSheet<InsightsTimeframe>(
    context: context,
    showDragHandle: false,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.timeframeTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            for (final value in InsightsTimeframe.values)
              ListTile(
                title: Text(value.label),
                trailing: value == current
                    ? const Icon(AppIcons.check, size: 20)
                    : null,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(value);
                },
              ),
            ListTile(
              title: const Text(AppStrings.cancel),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    },
  );
}
